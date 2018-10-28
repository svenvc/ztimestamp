"
I am ZTimezone, representing the timezone information in the standard Olsen database.

  http://en.wikipedia.org/wiki/Tz_database
  https://www.iana.org/time-zones

Usage

You reference timezones by their ID. The list of supported identifiers is accessible using

  ZTimezone timezoneIdentifiers.

To access a timezone do

  ZTimezone id: 'Europe/Brussels'.

The necessary information will be loaded, parsed and cached from a binary file of the zoneinfo database (see also man tzfile). This should work automagically on macOS and Unix, on Windows you have to download the necessary files and specify their location although there is a fallback that downloads the dataset (see #downloadFallbackZoneinfoDataset)

  ZTimezone zoneInfoLocation: FileLocator C / 'foo' / 'bar' / 'zoneinfo'.

Once you get a handle on a timezone, the main operation is to query the sub timezone that is applicable at a certain point in time 

  (ZTimezone id: 'Europe/Brussels') subzoneForTimestamp: ZTimestamp now.

The ZSubTimezone instance returned contains information like the UTC offset. Since you'll probably only be interested in that aspect there is a convenience method 

  (ZTimezone id: 'Europe/Brussels') offsetForTimestamp: DateAndTime now.

The flow is that for every GMT timestamp, you get the concrete offset to use for a specific timezone. Note that this is not a constant, it depends on the time periode the timestamp falls in.

The are 2 more convenience methods to quickly convert between GTM and local wall time 

  (ZTimezone id: #'Europe/Brussels') gmtToLocal: ZTimestamp now.
  (ZTimezone id: #'Europe/Brussels') localToGmt: DateAndTime now.

Also note the zoneTab and the timezones are cached in the image. When the TZ database changes, it might be necessary to either call #cleanUp or #reloadAll. When moving images between machines, either all info should be loaded and cached, or it might be necessary to use #zoneInfoLocation: again.

Implementation

A chronological array of transition points in unix time specifies which sub zone is active from that point on to the next.

Limitations

The format 2 data following the format 1 data is not read as it is a duplicate. Leap seconds, the standard/wall indicators and the UTC/local indicators are currently ignored, but their information is read and stored.
"
Class {
	#name : #ZTimezone,
	#superclass : #Object,
	#instVars : [
		'id',
		'transitions',
		'subzones',
		'leapSeconds',
		'standardIndicators',
		'utcIndicators',
		'subzonesIndex',
		'localTransitions'
	],
	#classVars : [
		'Timezones',
		'ZoneInfoLocation',
		'ZoneTab'
	],
	#category : #ZTimestamp
}

{ #category : #acccessing }
ZTimezone class >> centralEuropeanAliases [
	^ #(CET CEST)
]

{ #category : #private }
ZTimezone class >> checkMagicFrom: in [
	| version |
	self assert: (in next: 4) = 'TZif' asByteArray.
	version := in next.
	"version 0 is the traditional format.
	version 2 means that the normal data is followed an identical format
	where the offsets are specified using 8 instead of 4 bytes for future proofing"
	in skip: 15
]

{ #category : #utilties }
ZTimezone class >> cleanUp [
	"Clear our cached data"
	"self cleanUp"
	
	ZoneTab := Timezones := nil
]

{ #category : #private }
ZTimezone class >> count: count do: block [
	^ Array new: count streamContents: [ :out |
		count timesRepeat: [ block value: out ] ]
]

{ #category : #private }
ZTimezone class >> createGMT [
	^ self new
		id: #GMT;
		transitions: #();
		subzonesIndex: #[ 0 ];
		subzones: { ZSubTimezone gmt };
		resolveSubzonesIndex;
		yourself
]

{ #category : #private }
ZTimezone class >> createLocaltime [
	^ self new
		id: #localtime;
		transitions: #();
		subzonesIndex: #[ 0 ];
		subzones: { ZSubTimezone localtime };
		resolveSubzonesIndex;
		yourself
]

{ #category : #acccessing }
ZTimezone class >> defaultZoneCET [
	"The timezone identifiers in #centralEuropeanAliases resolve to this actual timezone"
	
	^ self id: 'Europe/Brussels'
]

{ #category : #acccessing }
ZTimezone class >> defaultZoneInfoLocation [
	"On macOS and Linux/Unix there is a standard location.
	On Windows there is not, so the location has to be specified using #zoneInfoLocation:
	On systems that do not seem to have the dataset at the normal location,
	we attempt to download a fallback copy in the current directory"

	| standardLocation |
	standardLocation := '/usr/share/zoneinfo/' asFileReference.
	standardLocation exists
		ifTrue: [ ^ standardLocation ].
	[ ^ self downloadFallbackZoneinfoDataset ] 
		on: Error 
		do: [ :exception |
			self notify: 'Failed to download fallback zoneinfo dataset with ' , exception printString.
			self errorCannotUseDefaultZoneInfoLocation ]
]

{ #category : #utilties }
ZTimezone class >> downloadFallbackZoneinfoDataset [
	"Download a fallback copy of the zoneinfo dataset and return its location.
	See #fallbackZoneinfoDatasetURL for more info and a warning"
	
	| zipLocation zoneinfoLocation |
	zipLocation := self fallbackZoneinfoDatasetURL file asFileReference.
	zipLocation ensureDelete.
	ZnClient new 
		url: self fallbackZoneinfoDatasetURL; 
		downloadTo: zipLocation;
		close.
	zoneinfoLocation := zipLocation parent / 'zoneinfo'.
	zoneinfoLocation ensureDeleteAll.
	ZipArchive new
		readFrom: zipLocation;
		extractAllTo: zoneinfoLocation parent;
		close.
	^ zoneinfoLocation
]

{ #category : #private }
ZTimezone class >> errorCannotUseDefaultZoneInfoLocation [
	^ self
		error:
			'Cannot default to standard /usr/share/zoneinfo/ location,' , 
			'please specify a location using #zoneInfoLocation:'
]

{ #category : #acccessing }
ZTimezone class >> fallbackZoneinfoDatasetURL [
	"The URL to the ZIP archive zoneinfo.zip which is offered as a fallback for 
	systems (such as Windows) that do no have their own copy of this data. 
	Note that it is highly recommended that you use such a OS maintained dataset, 
	as this data is changed (being added to) each year."
	
	^ 'https://github.com/svenvc/ztimestamp/raw/master/rsrc/zoneinfo.zip' asUrl
]

{ #category : #'instance creation' }
ZTimezone class >> fromFile: file [
	"Parse the binary compiled tzfile at file and return a timezone. Do not cache."
	"self fromFile: '/usr/share/zoneinfo/Europe/Brussels'."

	| fileReference |
	fileReference := file asFileReference.
	^ (fileReference respondsTo: #binaryReadStreamDo:)
		ifTrue: [ 
			fileReference binaryReadStreamDo: [ :in | 
				self fromStream: in ] ] 
		ifFalse: [ 
			fileReference readStreamDo: [ :in |
				in binary. 
				self fromStream: in ] ]
]

{ #category : #'instance creation' }
ZTimezone class >> fromStream: in [
	"Parse binary tzfile format data from in and return a timezone"
	
	| timezone header rawSubzones abbreviations |
	timezone := self new.
	self checkMagicFrom: in.
	header := self readHeaderFrom: in.
	timezone transitions: (self 
		count: (header at: #transitionCount) 
		do: [ :out | out nextPut: in int32 ]).
	timezone subzonesIndex: (in next: (header at: #transitionCount)).
	rawSubzones := self
		count: (header at: #typeCount)
		do: [ :out | out nextPut: { in int32. in next. in next } ].
	timezone leapSeconds: (self
		count: (header at: #leapCount)
		do: [ :out | out nextPut: { in uint32. in uint32 } ]).
	abbreviations := (in next: (header at: #abbreviationCount)) asString. 
	timezone resolveSubzones: rawSubzones abbreviations: abbreviations.
	timezone resolveStandardIndicators: (in next: (header at: #wallCount)).
	timezone resolveUtcIndicators: (in next: (header at: #utcCount)).
	^ timezone
]

{ #category : #'instance creation' }
ZTimezone class >> gmt [
	"Return the special GMT timezone, also known as UTC or Zulu"
	
	^ self timezones at: #GMT ifAbsentPut: [ self createGMT ]
]

{ #category : #acccessing }
ZTimezone class >> gmtAliases [
	^ #(GMT UTC Z Zulu Zero)
]

{ #category : #'instance creation' }
ZTimezone class >> id: id [
	"Return the timezone identified by id, either from cache or loading it if necessary.
	See #timezoneIdentifiers for the list of available identifiers. id is case sensitive."
	
	(self gmtAliases includes: id) 
		ifTrue: [ ^ self gmt ].
	(self localtimeAliases includes: id)
		ifTrue: [ ^ self localtime ].
	(self centralEuropeanAliases includes: id) 
		ifTrue: [ ^ self defaultZoneCET ] .

	^ self timezones
		at: id
		ifAbsentPut: [ self readTimezoneWithId: id ]
]

{ #category : #'instance creation' }
ZTimezone class >> localtime [
	"Return the special localtime timezone, 
	containing the current local timezone offset as one fixed transition.
	Note that the cached version might go stale after DST transitions (use #cleanUp)"
	
	^ self timezones at: #localtime ifAbsentPut: [ self createLocaltime ]
]

{ #category : #acccessing }
ZTimezone class >> localtimeAliases [
	^ #(local localtime)
]

{ #category : #acccessing }
ZTimezone class >> locationForId: id [
	"Return a FileReference to the file containing the compiled binary data 
	for the timezone identified by id, with $/ indicating directory levels"
	
	^ self locationForId: id relativeTo: self zoneInfoLocation
]

{ #category : #acccessing }
ZTimezone class >> locationForId: id relativeTo: zoneInfoLocation [
	"Return a FileReference to the file containing the compiled binary data 
	for the timezone identified by id, with $/ indicating directory levels,
	starting at (i.e. relative to) the directory zoneInfoLocation"
	
	| location |
	location := zoneInfoLocation asFileReference.
	($/ split: id) do: [ :each |
		location := location / each ].
	^ location
]

{ #category : #private }
ZTimezone class >> readHeaderFrom: in [
	| header |
	header := Dictionary new.
	#(#utcCount #wallCount #leapCount #transitionCount #typeCount #abbreviationCount)
		do: [ :each | header at: each put: in uint32 ].
	^ header
]

{ #category : #'instance creation' }
ZTimezone class >> readTimezoneWithId: id [
	"Parse and load the timezone with id, do not cache"

	"self readTimezoneWithId: #'Europe/Brussels'."

	| location timezone |
	self zoneTab 
		detect: [ :each | each first = id ] 
		ifNone: [ ^ self error: 'Unknown Timezone ID: ' , id asString ].
	location := self locationForId: id.
	timezone := self fromFile: location.
	timezone id: id.
	^ timezone
]

{ #category : #utilties }
ZTimezone class >> readZoneTab [
	"Parse and load the zone tab file, do not cache"
	"self readZoneTab"

	^ self readZoneTabFrom: self zoneInfoLocation
]

{ #category : #utilties }
ZTimezone class >> readZoneTabFrom: zoneInfoLocation [
	"Parse and load the zone tab file from zoneInfoLocation, do not cache"

	| file contents |
	file := zoneInfoLocation asFileReference / 'zone.tab'.
	contents := file readStreamDo: [ :in | in upToEnd ].
	^ (contents lines reject: [ :line | line first = $# ])
			collect: [ :lines | 
				| tokens |
				tokens := lines findTokens: Character separators.
				{ tokens third asSymbol. tokens first } ]
]

{ #category : #utilties }
ZTimezone class >> reloadAll [
	"Clear all cached data and load ALL timezone data. Do cache."
	"self reloadAll"
	
	self cleanUp.
	self timezoneIdentifiers 
		do: [ :each | self id: each ].
	^ self timezones
]

{ #category : #acccessing }
ZTimezone class >> resetZoneInfoLocation [
	"Reset the zone info database location so that the default will be used"
	
	self zoneInfoLocation: nil
]

{ #category : #utilties }
ZTimezone class >> statistics [
	"Give an indication of the amount of data I currently cache"
	"self statistics."
	
	^ { 
			#totalTimezones -> self timezones size.
			#totalTransitions -> (self timezones sum: [ :each | each transitions size ]).
			#totalSubzones -> (self timezones sum: [ :each | each subzones size ])
		} asDictionary 
]

{ #category : #acccessing }
ZTimezone class >> timezoneIdentifiers [
	"Return the list of supported timezone identifiers.
	#gmtAliases and #localtimeAliases are special cases that are also supported, 
	but are not in the zonetab. Identifiers are case sensitive."
	
	^ self zoneTab collect: #first
]

{ #category : #acccessing }
ZTimezone class >> timezones [
	"Return the currently cached timezones as a Dictionary"
	
	^ Timezones ifNil: [ Timezones := Dictionary new ]
]

{ #category : #acccessing }
ZTimezone class >> zoneInfoLocation [
	"Return the zone info database location currently in use"
	
	^ ZoneInfoLocation ifNil: [ ZoneInfoLocation := self defaultZoneInfoLocation ]
]

{ #category : #acccessing }
ZTimezone class >> zoneInfoLocation: directory [
	"Set the location of the zone info database to directory"
	
	ZoneInfoLocation := directory asFileReference
]

{ #category : #acccessing }
ZTimezone class >> zoneTab [
	"Return the zone tab, a list of pairs, timezone identifier and country code"
	
	^ ZoneTab ifNil: [ ZoneTab := self readZoneTab ]
]

{ #category : #private }
ZTimezone >> byteArrayToBits: byteArray [
	| bits |
	bits := 0.
	byteArray withIndexDo: [ :each :index |
		bits := bits bitAt: index put: each ].
	^ bits
]

{ #category : #convenience }
ZTimezone >> gmtToLocal: timestamp [
	"Return a copy of timestamp shifted from GMT to 
	the local wall time as defined by the receiver.
	This works as long as timestamp understands #asUnixTime and #+"

	| offset |
	offset := self offsetForTimestamp: timestamp.
	^ timestamp + offset
]

{ #category : #accessing }
ZTimezone >> id [
	^ id
]

{ #category : #accessing }
ZTimezone >> id: anObject [
	id := anObject asSymbol
]

{ #category : #accessing }
ZTimezone >> leapSeconds [
	^ leapSeconds
]

{ #category : #accessing }
ZTimezone >> leapSeconds: anObject [
	leapSeconds := anObject
]

{ #category : #convenience }
ZTimezone >> localToGmt: timestamp [
	"Return a copy of timestamp shifted from the local wall time 
	as defined by the receiver to GMT.
	This works as long as timestamp understands #asUnixTime and #-"

	| offset |
	offset := self offsetForLocalTimestamp: timestamp.
	^ timestamp - offset
]

{ #category : #accessing }
ZTimezone >> localTransitions [
	"Lazily computed transition table in local wall time"

	^ localTransitions
		ifNil: [ 
			localTransitions := self transitions
				withIndexCollect: [ :each :index | 
					each + (self subzoneForTransitionAt: index) offset asSeconds ] ]
]

{ #category : #public }
ZTimezone >> offsetForLocalTimestamp: timestamp [
	"Return the offset Duration to be subtracted from timestamp (interpreted as
	local wall time) to get the correct GMT time in the timezone that I represent.
	The offset depends on the point in time (summer/winter time, history).
	All objects that respond to #asUnixTime can serve as a timestamp."
	
	| subzone |
	subzone := self subzoneForLocalTimestamp: timestamp.
	^ subzone offset 
]

{ #category : #public }
ZTimezone >> offsetForTimestamp: timestamp [
	"Return the offset Duration to be added to timestamp (interpreted as GMT)
	to get the correct local wall time in the timezone that I represent.
	The offset depends on the point in time (summer/winter time, history).
	All objects that respond to #asUnixTime can serve as a timestamp."
	
	| subzone |
	subzone := self subzoneForTimestamp: timestamp.
	^ subzone offset 
]

{ #category : #printing }
ZTimezone >> printOn: stream [
	super printOn: stream.
	stream nextPut: $(.
	id ifNotNil: [ stream << id ].
	stream nextPut: $)
]

{ #category : #private }
ZTimezone >> resolveStandardIndicators: flags [
	self standardIndicators: (self byteArrayToBits: flags)
]

{ #category : #private }
ZTimezone >> resolveSubzones: rawSubzones abbreviations: abbreviations [
	subzones := rawSubzones collect: [ :each | 
		| start stop |
		start := each third + 1.
		stop := abbreviations indexOf: Character null startingAt: start.
		ZSubTimezone 
			abbreviation: (abbreviations copyFrom: start to: stop - 1) 
			offset: each first seconds
			dst: each second = 1 ].
	self resolveSubzonesIndex 
]

{ #category : #private }
ZTimezone >> resolveSubzonesIndex [
	| resolvedSubzonesIndex |
	resolvedSubzonesIndex := Array new: subzonesIndex size.
	1 to: subzonesIndex size do: [ :each |
		| index |
		index := (subzonesIndex at: each) + 1.
		resolvedSubzonesIndex at: each put: (subzones at: index) ].
	subzonesIndex := resolvedSubzonesIndex 
]

{ #category : #private }
ZTimezone >> resolveUtcIndicators: flags [
	self utcIndicators: (self byteArrayToBits: flags)
]

{ #category : #accessing }
ZTimezone >> resolvedLocalTransitions [
	^ self localTransitions
		with: self subzonesIndex
		collect: [ :transition :subzone | (ZTimestamp fromUnixTime: transition) -> subzone ]
]

{ #category : #accessing }
ZTimezone >> resolvedTransitions [
	^ self transitions
		with: self subzonesIndex
		collect: [ :transition :subzone | (ZTimestamp fromUnixTime: transition) -> subzone ]
]

{ #category : #accessing }
ZTimezone >> standardIndicators [
	^ standardIndicators
]

{ #category : #accessing }
ZTimezone >> standardIndicators: anObject [
	standardIndicators := anObject
]

{ #category : #public }
ZTimezone >> subzoneForLocalTimestamp: timestamp [
	"Return the ZSubTimezone instance for timestamp (interpreted as local wall time)
	to get the correct GMT time in the timezone that I represent.
	The returned object knows the offet Duration to be subtracted, 
	the timezone abbreviation and whether daylight saving was in effect or not.
	The subzone depends on the point in time (summer/winter time, history).
	All objects that respond to #asUnixTime can serve as a timestamp."

	^ self subzoneForLocalUnixTime: timestamp asUnixTime 
]

{ #category : #public }
ZTimezone >> subzoneForLocalUnixTime: unixTime [
	"Given unixTime, the number of seconds since 1970-01-01, 
	return the TSubTimezone containing more information,
	applicable to that point in time (interpreted in local wall time)."
	
	^ self localTransitions
		findBinaryIndex: [ :offset | unixTime - offset ]
		do: [ :index | self subzoneForTransitionAt: index ]
		ifNone: [ :lower :upper | 
			| index |
			index := lower ~= 0
				ifTrue: [ lower ]																
				ifFalse: [ upper ].
			self subzoneForTransitionAt: index ]
]

{ #category : #public }
ZTimezone >> subzoneForTimestamp: timestamp [
	"Return the ZSubTimezone instance for timestamp (interpreted as GMT)
	to get the correct local wall time in the timezone that I represent.
	The returned object knows the offet Duration to be added, the timezone 
	abbreviation and whether daylight saving was in effect or not.
	The subzone depends on the point in time (summer/winter time, history).
	All objects that respond to #asUnixTime can serve as a timestamp."

	^ self subzoneForUnixTime: timestamp asUnixTime 
]

{ #category : #private }
ZTimezone >> subzoneForTransitionAt: index [
	^ subzonesIndex at: index
]

{ #category : #public }
ZTimezone >> subzoneForUnixTime: unixTime [
	"Given unixTime, the number of seconds since 1970-01-01, 
	return the TSubTimezone containing more information,
	applicable to that point in time (interpreted in GMT)."
	
	^ self transitions
		findBinaryIndex: [ :offset | unixTime - offset ]
		do: [ :index | self subzoneForTransitionAt: index ]
		ifNone: [ :lower :upper | 
			| index |
			index := lower ~= 0
				ifTrue: [ lower ]																
				ifFalse: [ upper ].
			self subzoneForTransitionAt: index ]
]

{ #category : #accessing }
ZTimezone >> subzones [
	^ subzones
]

{ #category : #accessing }
ZTimezone >> subzones: anObject [
	subzones := anObject
]

{ #category : #accessing }
ZTimezone >> subzonesIndex [
	^ subzonesIndex
]

{ #category : #accessing }
ZTimezone >> subzonesIndex: anObject [
	subzonesIndex := anObject
]

{ #category : #accessing }
ZTimezone >> transitions [
	^ transitions
]

{ #category : #accessing }
ZTimezone >> transitions: anObject [
	transitions := anObject
]

{ #category : #accessing }
ZTimezone >> utcIndicators [
	^ utcIndicators
]

{ #category : #accessing }
ZTimezone >> utcIndicators: anObject [
	utcIndicators := anObject
]
