"
I am ZTimestampFormat, an implementation of a textual representation for a timestamp, date or time that can be used for formatting or parsing.

You instanciate me by specifying the textual format by example, based on a #reference24 or #reference12 timetamp. 

Each component of the example representation is numbered from largest to smallest unit:

	1=year
	2=month
	3=dayInMonth
	4=hour (16 in 24 hour format)
	5=minute
	6=second

as in the ISO representation: 

	2001-02-03T16:05:06Z which is a Saterday. 

Example format strings can be found in my class accessing protocol or in the unit tests.

To specifiy a format, you write the reference date so that it matches the representation that you want.

	(ZTimestampFormat fromString: 'SAT, FEB 03 2001 (16:05:06)')
		format: ZTimestamp now.

I can be used for unabiguous, stricter parsing as well.

	(ZTimestampFormat fromString: '02/03/01 (16:05:06)')
		parse: '10/10/10 (12:01:01)'.
		
The list of possible keys and their interpretation is defined in #formatSpecifications.
I can translate month and weekday names to 4 different languages, English, French, German and Dutch.
I can optionally use a timezone to convert UTC/GMT/Zulu timestamps to local time.

Additionally I can be build directly from #formatElements using methods from my elements protocol.
The following are equivalent, the first one specified by an example, the second one constructed.

	ZTimestampFormat isoDate.
	ZTimestampFormat new yearFourDigits; constant: $/; monthTwoDigits; constant: $/; dayTwoDigits.

In the internal implementation there is a direct, one to one mapping between the following:

 - the format key '2'
 - the format value #month
 - the specification substring '2'
 - the element #month
 - the formatter #formatMonth:on:
 - the parser #parseMonthFrom:

The constructor element value key #month is used for all month variants, #month, #momthTwoDigits and #monthName[Abbreviated][Capitalized|Uppercased|Lowercased] since they all lead to the same month number.

"
Class {
	#name : 'ZTimestampFormat',
	#superclass : 'Object',
	#instVars : [
		'specification',
		'elements',
		'formatter',
		'parser',
		'constructor',
		'weekdayNames',
		'monthNames',
		'timezone'
	],
	#classVars : [
		'FormatKeys',
		'Formats'
	],
	#category : 'ZTimestamp-Core',
	#package : 'ZTimestamp-Core'
}

{ #category : 'accessing' }
ZTimestampFormat class >> abbreviatedTimeZones [
	"Map TimeZone abbreviations to their offsets"
	"Order matters for lookup by offset !"
	"Initially created then edited by hand using"
	"TimeZone timeZones collect: [ :each | { each abbreviation. each offset hours } ]"

	^ #(
		#('UTC' 0) 
		#('GMT' 0) 
		#('CET' 1)
		#('BST' 1) 
		#('SAST' 2) 
		#('PST' -8) 
		#('PDT' -7) 
		#('MST' -7) 
		#('MDT' -6) 
		#('CST' -6) 
		#('CDT' -5) 
		#('EST' -5) 
		#('EDT' -4)
		#('CEST' 2) 
		)
]

{ #category : 'accessing' }
ZTimestampFormat class >> ansiC [
	"ANSI C date/time format"
	"WeekdayAbbreviated MonthNameAbbreviated DayInMonth HH:MM:SS Year"
	"ZTimestampFormat ansiC format: ZTimestamp now"
	
	<gtExample>
	
	^ self fromString: 'Sat Feb _3 16:05:06 2001'
]

{ #category : 'accessing' }
ZTimestampFormat class >> clock [
	"Simple 24 hour clock format"
	"HH:MM"
	"ZTimestampFormat clock format: ZTimestamp now"
	"ZTimestampFormat clock format: Time now"
	
	<gtExample>

	^ self fromString: '16:05'
]

{ #category : 'accessing' }
ZTimestampFormat class >> euDate [
	"Most common EU format"
	"DD/MM/YYYY"
	"ZTimestampFormat euDate format: ZTimestamp today"
	"ZTimestampFormat euDate format: Date today"
	
	<gtExample>

	^ self fromString: '03/02/2001'
]

{ #category : 'accessing' }
ZTimestampFormat class >> formatElements [
	"Return the collection of recognized format elements.
	For each element there is a corresponding builder method in the elements protocol."
	
	^ Formats values sort
	
"self formatElements collect: [ :each | | sourceCode |
	sourceCode := '{1}
	self elements add: #{1}' format: { each }.
	ZTimestampFormat compile: sourceCode classified: 'elements' ]."
]

{ #category : 'accessing' }
ZTimestampFormat class >> formatKeys [
	"Return the collection of recognized format keys in specifications"
	
	^ FormatKeys 
]

{ #category : 'accessing' }
ZTimestampFormat class >> formatSpecifications [
	"A collection pair-wise defining format keys recognized in specifications with their interpretation.
	See the 'parsers' and 'formatter' instance side protocols with methods for each interpretation."
	
	^ #(
		'2001' yearFourDigits
		'01' yearTwoDigits
		'02001' yearFull
		'02' monthTwoDigits
		'2' month
		'February' monthNameCapitalized
		'february' monthNameLowercased
		'FEBRUARY' monthNameUppercased
		'Feb' monthNameAbbreviatedCapitalized
		'feb' monthNameAbbreviatedLowercased
		'FEB' monthNameAbbreviatedUppercased
		'3' day
		'_3' dayTwoDigitsSpacePadded
		'03' dayTwoDigits
		'4' hour12
		'04' hour12TwoDigits
		'16' hour24TwoDigits
		'PM' daypartUppercased
		'pm' daypartLowercased
		'5' minute
		'05' minuteTwoDigits
		'6' second
		'06' secondTwoDigits
		'7' nanosecond
		'Z' timeZoneZ
		'+00:00' timeZone
		'UTC' timeZoneAbbreviated
		'_UTC' timeZoneAbbreviatedLong
		'Saturday' weekdayNameCapitalized
		'saturday' weekdayNameLowercased
		'SATURDAY' weekdayNameUppercased
		'Sat' weekdayNameAbbreviatedCapitalized
		'sat' weekdayNameAbbreviatedLowercased
		'SAT' weekdayNameAbbreviatedUppercased )
]

{ #category : 'accessing' }
ZTimestampFormat class >> formats [
	"Return a dictionary mapping each format key with its interpretation (see #formatSpecifications)"
	
	^ Formats
]

{ #category : 'instance creation' }
ZTimestampFormat class >> fromString: example [
	"Create an instance of me, based on the example."
	
	^ self new
		specification: example;
		yourself
	
]

{ #category : 'class initialization' }
ZTimestampFormat class >> initialize [
	"Initialize this class, to be redone every time #formatSpecifications changes."
	
	"self initialize."
	
	Formats := Dictionary newFromPairs: self formatSpecifications.
	FormatKeys := Formats keys sorted: [ :x :y | x size >= y size ]
]

{ #category : 'accessing' }
ZTimestampFormat class >> iso [
	"The standard ISO 8601 date/time format with separators"
	"YYYY-MM-DDTHH:MM:SSZ"
	"ZTimestampFormat iso format: ZTimestamp now"
	"ZTimestampFormat iso format: DateAndTime now"
	
	<gtExample>
	
	^ self fromString: '2001-02-03T16:05:06Z'
]

{ #category : 'accessing' }
ZTimestampFormat class >> isoCompact [
	"The standard ISO 8601 date/time format with minimal separators and implied timezone UTC"
	"YYYYMMDDTHHMMSS"
	"ZTimestampFormat isoCompact format: ZTimestamp now"
	
	<gtExample>

	^ self fromString: '20010203T160506'
]

{ #category : 'accessing' }
ZTimestampFormat class >> isoDate [
	"ISO date format"
	"YYYY/MM/DD"
	"ZTimestampFormat isoDate format: ZTimestamp now"
	
	<gtExample>

	^ self fromString: '2001/02/03'
]

{ #category : 'accessing' }
ZTimestampFormat class >> isoNanoTZ [
	"The standard ISO 8601 date/time format with separators, nanosecond precision and full timezone offset"
	"YYYY-MM-DDTHH:MM:SS.NNNNNNNNN+ZZ:zz"
	"ZTimestampFormat isoTZ format: ZTimestamp now"
	"ZTimestampFormat isoTZ format: DateAndTime now"
	
	<gtExample>

	^ self fromString: '2001-02-03T16:05:06.7+00:00'
]

{ #category : 'accessing' }
ZTimestampFormat class >> isoTZ [
	"The standard ISO 8601 date/time format with separators with full timezone offset"
	"YYYY-MM-DDTHH:MM:SS+ZZ:zz"
	"ZTimestampFormat isoTZ format: ZTimestamp now"
	"ZTimestampFormat isoTZ format: DateAndTime now"
	
	<gtExample>

	^ self fromString: '2001-02-03T16:05:06+00:00'
]

{ #category : 'accessing' }
ZTimestampFormat class >> kitchen [
	"Simple 12 hour clock format"
	"HH:MM"
	"ZTimestampFormat kitchen format: ZTimestamp now"
	"ZTimestampFormat kitchen format: Time now"
	
	<gtExample>

	^ self fromString: '04:05PM'
]

{ #category : 'accessing' }
ZTimestampFormat class >> reference12 [
	"The ZTimestamp instance used as a reference for specifying a format by example.
	The possible components are numbered from largest to smallest unit."
	
	<gtExample>

	^ ZTimestamp year: 2001 month: 2 day: 3 hour: 4 minute: 5 second: 6
]

{ #category : 'accessing' }
ZTimestampFormat class >> reference24 [
	"The ZTimestamp instance used as a reference for specifying a format by example.
	The possible components are numbered from largest to smallest unit."
	
	<gtExample>

	^ ZTimestamp year: 2001 month: 2 day: 3 hour: 16 minute: 5 second: 6
]

{ #category : 'accessing' }
ZTimestampFormat class >> rfc3339 [
	"RFC3339 based layout"

	<gtExample>
	
	^ self iso
]

{ #category : 'accessing' }
ZTimestampFormat class >> rfc822 [
	"RFC 822 email format"
	"DayInMonth MonthNameAbbreviated Year2Digits HH:MM TimezoneAbbreviated"
	"ZTimestampFormat rfc822 format: ZTimestamp now"
	
	<gtExample>
	
	^ self fromString: '03 Feb 01 16:05 UTC'
]

{ #category : 'accessing' }
ZTimestampFormat class >> rfc850 [
	"RFC 850 usenet format"
	"WeekdayName, DayInMonth-MonthNameAbbreviated-Year2Digits HH:MM TimezoneAbbreviated"
	"ZTimestampFormat rfc850 format: ZTimestamp now"
	
	<gtExample>

	^ self fromString: 'Saturday, 03-Feb-01 16:05:06 UTC'
]

{ #category : 'accessing' }
ZTimestampFormat class >> rfc9110 [
	"The HTTP date format https://datatracker.ietf.org/doc/html/rfc9110#section-5.6.7
	Note that this specification does not include the legacy formats rfc850 and ansiC"
	"ZTimestampFormat rfc9110 parse: 'Sun, 06 Nov 1994 08:49:37 GMT'"
	"ZTimestampFormat rfc9110 format: (ZTimestamp year: 1994 month: 11 day: 6 hour: 8 minute: 49 second: 37)"
	
	<gtExample>
	
	^ self fromString: 'Sat, 03 Feb 2001 16:05:06 GMT'
]

{ #category : 'accessing' }
ZTimestampFormat class >> unixDate [
	"Unix format as used by the date command line command"
	"WeekdayNameAbbreviated MonthNameAbbreviated DayInMonth HH:MM:SS TimezoneAbbreviated Year"
	"ZTimestampFormat unixDate format: ZTimestamp now"
	
	<gtExample>
	
	^ self fromString: 'Sat Feb _3 16:05:06 UTC 2001'
]

{ #category : 'accessing' }
ZTimestampFormat class >> usDate [
	"The common US format"
	"MM/DD/YYYY"
	"ZTimestampFormat usDate format: ZTimestamp today"
	"ZTimestampFormat usDate format: Date today"
	
	<gtExample>

	^ self fromString: '02/03/2001'
]

{ #category : 'accessing' }
ZTimestampFormat class >> verbose [
	"A verbose, non-abbreviated format"
	"WeekdayName, DayInMonth-MonthName-Year HH:MM:SS DayPart (+ZZ:zz"
	"ZTimestampFormat verbose format: ZTimestamp now"
	"ZTimestampFormat verbose format: DateAndTime now"
	
	<gtExample>

	^ self fromString: 'Saturday, 03-February-2001 04:05:06 PM (+00:00)'
]

{ #category : 'private' }
ZTimestampFormat >> abbreviationForTimeZoneOffset: offset [
	"(TimeZone offset: offset) abbreviation"

	self class abbreviatedTimeZones
		do: [ :each | 
			each second = offset hours
				ifTrue: [ ^ each first ] ].
	self error: 'Cannot find time zone for offset ' , offset asString
]

{ #category : 'private' }
ZTimestampFormat >> actualOffsetForTimestamp: timestamp [
	^ self timezone value
		ifNil: [ timestamp offset ]
		ifNotNil: [ :actualTimezone | actualTimezone offsetForTimestamp: timestamp ]
]

{ #category : 'private' }
ZTimestampFormat >> compileSpecification [
	elements := self elementsFromSpecification.
	formatter := self formatterFromElements.
	parser := self parserFromElements
]

{ #category : 'elements' }
ZTimestampFormat >> constant: character [
	self elements add: character
]

{ #category : 'accessing' }
ZTimestampFormat >> constructor [
	^ constructor
]

{ #category : 'accessing' }
ZTimestampFormat >> constructor: block [
	"Set my constructor, a block that creates instances based on parsed elements, passed in as a dictionary.
	See #createZTimestamp, #createDateAndTime and friends."
	
	constructor := block
]

{ #category : 'initialize-release' }
ZTimestampFormat >> createDate [
	"Configure me to create Date instances when parsing"
	
	self constructor: [ :elementValues | 
		Date 
			year: (elementValues at: #year ifAbsent: [ 0 ]) 
			month: (elementValues at: #month ifAbsent: [ 0 ])  
			day: (elementValues at: #day ifAbsent: [ 0 ]) ]
]

{ #category : 'initialize-release' }
ZTimestampFormat >> createDateAndTime [
	"Configure me to create DateAndTime instances when parsing"

	self constructor: [ :elementValues | 
		| timestamp |
		timestamp := DateAndTime 
			year: (elementValues at: #year ifAbsent: [ 0 ]) 
			month: (elementValues at: #month ifAbsent: [ 0 ])  
			day: (elementValues at: #day ifAbsent: [ 0 ])  
			hour: (elementValues at: #hour ifAbsent: [ 0 ]) 
			minute: (elementValues at: #minute ifAbsent: [ 0 ])  
			second: (elementValues at: #second ifAbsent: [ 0 ]) 
			nanoSecond: (elementValues at: #nanosecond ifAbsent: [ 0 ])
			offset: (elementValues at: #offset ifAbsent: [ Duration zero ]).
		(elementValues includesKey: #offset)
			ifTrue: [ timestamp ]
			ifFalse: [ self localToGmt: timestamp ] ]
]

{ #category : 'private' }
ZTimestampFormat >> createInstanceFrom: elementValues [
	elementValues 
		at: #daypart 
		ifPresent: [ :daypart | | hour |
			hour :=  elementValues at: #hour.
			(daypart = #pm and: [ hour < 12 ])
				ifTrue: [ elementValues at: #hour put: hour + 12 ].
			(daypart = #am and: [ hour = 12 ])
				ifTrue: [ elementValues at: #hour put: 0 ] ].
	^ self constructor value: elementValues
]

{ #category : 'initialize-release' }
ZTimestampFormat >> createTime [
	"Configure me to create Time instances when parsing"

	self constructor: [ :elementValues | 
		Time 
			hour: (elementValues at: #hour ifAbsent: [ 0 ]) 
			minute: (elementValues at: #minute ifAbsent: [ 0 ])  
			second: (elementValues at: #second ifAbsent: [ 0 ]) ]
]

{ #category : 'initialize-release' }
ZTimestampFormat >> createZTimestamp [
	"Configure me to create ZTimestamp instances when parsing (this is the default)"

	self constructor: [ :elementValues | 
		| timestamp |
		timestamp := ZTimestamp 
			year: (elementValues at: #year ifAbsent: [ 0 ]) 
			month: (elementValues at: #month ifAbsent: [ 0 ])  
			day: (elementValues at: #day ifAbsent: [ 0 ])  
			hour: (elementValues at: #hour ifAbsent: [ 0 ]) 
			minute: (elementValues at: #minute ifAbsent: [ 0 ])  
			second: (elementValues at: #second ifAbsent: [ 0 ]) 
			nanoSecond: (elementValues at: #nanosecond ifAbsent: [ 0 ])
			offset: (elementValues at: #offset ifAbsent: [ 0 ]).
		(elementValues includesKey: #offset)
			ifTrue: [ timestamp ]
			ifFalse: [ self localToGmt: timestamp ] ]
]

{ #category : 'initialize-release' }
ZTimestampFormat >> createZTimestampDefaultDate111 [
	"Configure me to create ZTimestamp instances when parsing where the default date is 1-1-1.
	This is a (not so useful) hack to ignore the date component (but keep it a legal value), mainly used for testing."

	self constructor: [ :elementValues | 
		| timestamp |
		timestamp := ZTimestamp 
			year: (elementValues at: #year ifAbsent: [ 1 ]) 
			month: (elementValues at: #month ifAbsent: [ 1 ])  
			day: (elementValues at: #day ifAbsent: [ 1 ])  
			hour: (elementValues at: #hour ifAbsent: [ 0 ]) 
			minute: (elementValues at: #minute ifAbsent: [ 0 ])  
			second: (elementValues at: #second ifAbsent: [ 0 ]) 
			offset: (elementValues at: #offset ifAbsent: [ 0 ]).
		(elementValues includesKey: #offset)
			ifTrue: [ timestamp ]
			ifFalse: [ self localToGmt: timestamp ] ]
]

{ #category : 'elements' }
ZTimestampFormat >> day [
	self elements add: #day
]

{ #category : 'elements' }
ZTimestampFormat >> dayTwoDigits [
	self elements add: #dayTwoDigits
]

{ #category : 'elements' }
ZTimestampFormat >> dayTwoDigitsSpacePadded [
	self elements add: #dayTwoDigitsSpacePadded
]

{ #category : 'elements' }
ZTimestampFormat >> daypartLowercased [
	self elements add: #daypartLowercased
]

{ #category : 'elements' }
ZTimestampFormat >> daypartUppercased [
	self elements add: #daypartUppercased
]

{ #category : 'initialize-release' }
ZTimestampFormat >> dutch [
	self monthNames: #( 
		'Januari' 'Februari' 'Maart' 'April' 'Mei' 'Juni' 
		'Juli' 'Augustus' 'September' 'Oktober' 'November' 'December' ).
	self weekdayNames: #( 
		'Zondag' 'Maandag' 'Dinsdag' 'Woensdag' 'Donderdag' 'Vrijdag' 'Zaterdag' )
]

{ #category : 'accessing' }
ZTimestampFormat >> elements [
	^ elements ifNil: [ elements := OrderedCollection new ]
]

{ #category : 'private' }
ZTimestampFormat >> elementsFromSpecification [
	| offset |
	^ Array
		streamContents: [ :stream | 
			offset := 1.
			[ offset <= specification size ]
				whileTrue: [ (self nextFormatKeyStartingAt: offset)
						ifNotNil: [ :formatKey | 
							stream nextPut: (self class formats at: formatKey).
							offset := offset + formatKey size ]
						ifNil: [ stream nextPut: (specification at: offset).
							offset := offset + 1 ] ] ]
]

{ #category : 'initialize-release' }
ZTimestampFormat >> english [
	self monthNames: #( 
		January February March April May June 
		July August September October November December).
	self weekdayNames: #( 
		Sunday Monday Tuesday Wednesday Thursday Friday Saturday )
]

{ #category : 'formatting' }
ZTimestampFormat >> format: object [
	"Format object according to my specification and return a string"
	
	^ String streamContents: [ :stream |
			self format: object on: stream ]
]

{ #category : 'formatters' }
ZTimestampFormat >> format: object dayOn: stream [
	object dayOfMonth printOn: stream
]

{ #category : 'formatters' }
ZTimestampFormat >> format: object dayTwoDigitsOn: stream [
	object dayOfMonth printOn: stream base: 10 length: 2 padded: true
]

{ #category : 'formatters' }
ZTimestampFormat >> format: object dayTwoDigitsSpacePaddedOn: stream [
	object dayOfMonth < 10
		ifTrue: [ stream space ].
	object dayOfMonth printOn: stream
]

{ #category : 'formatters' }
ZTimestampFormat >> format: object daypartLowercasedOn: stream [
	stream << (object hour < 12 ifTrue: [ #am ] ifFalse: [ #pm ])
]

{ #category : 'formatters' }
ZTimestampFormat >> format: object daypartUppercasedOn: stream [
	stream << (object hour < 12 ifTrue: [ #AM ] ifFalse: [ #PM ])
]

{ #category : 'formatters' }
ZTimestampFormat >> format: object hour12On: stream [
	| hour |
	hour := object hour.
	(hour > 12
		ifTrue: [ hour - 12 ]
		ifFalse: [ 
			hour < 1
				ifTrue: [ 12 ]
				ifFalse: [ hour ] ]) printOn: stream
]

{ #category : 'formatters' }
ZTimestampFormat >> format: object hour12TwoDigitsOn: stream [
	| hour |
	hour := object hour.
	(hour > 12
		ifTrue: [ hour - 12 ]
		ifFalse: [ 
			hour < 1
				ifTrue: [ 12 ]
				ifFalse: [ hour ] ]) printOn: stream base: 10 length: 2 padded: true
]

{ #category : 'formatters' }
ZTimestampFormat >> format: object hour24TwoDigitsOn: stream [
	object hour printOn: stream base: 10 length: 2 padded: true
]

{ #category : 'formatters' }
ZTimestampFormat >> format: object minuteOn: stream [
	object minute printOn: stream
]

{ #category : 'formatters' }
ZTimestampFormat >> format: object minuteTwoDigitsOn: stream [
	object minute printOn: stream base: 10 length: 2 padded: true
]

{ #category : 'formatters' }
ZTimestampFormat >> format: object monthNameAbbreviatedCapitalizedOn: stream [
	stream << ((self monthNames at: object monthIndex) copyFrom: 1 to: 3)
]

{ #category : 'formatters' }
ZTimestampFormat >> format: object monthNameAbbreviatedLowercasedOn: stream [
	stream << ((self monthNames at: object monthIndex) copyFrom: 1 to: 3) asLowercase 
]

{ #category : 'formatters' }
ZTimestampFormat >> format: object monthNameAbbreviatedUppercasedOn: stream [
	stream << ((self monthNames at: object monthIndex) copyFrom: 1 to: 3) asUppercase 
]

{ #category : 'formatters' }
ZTimestampFormat >> format: object monthNameCapitalizedOn: stream [
	stream << (self monthNames at: object monthIndex)
]

{ #category : 'formatters' }
ZTimestampFormat >> format: object monthNameLowercasedOn: stream [
	stream << (self monthNames at: object monthIndex) asLowercase 
]

{ #category : 'formatters' }
ZTimestampFormat >> format: object monthNameUppercasedOn: stream [
	stream << (self monthNames at: object monthIndex) asUppercase 
]

{ #category : 'formatters' }
ZTimestampFormat >> format: object monthOn: stream [
	object monthIndex printOn: stream
]

{ #category : 'formatters' }
ZTimestampFormat >> format: object monthTwoDigitsOn: stream [
	object monthIndex printOn: stream base: 10 length: 2 padded: true
]

{ #category : 'formatters' }
ZTimestampFormat >> format: object nanosecondOn: stream [
	| n len |
	n := object nanoSecond.
	n ~=0
		ifTrue: [  
			len := 9.
			[ n \\ 10 = 0 ] whileTrue: [ 
				n := n / 10.
				len := len - 1 ] ] 
		ifFalse: [ len := 1 ].
	n printOn: stream base: 10 length: len padded: true
]

{ #category : 'formatting' }
ZTimestampFormat >> format: object on: stream [
	"Format object on stream according to my specification"

	| local offset|
	local := self gmtToLocal: object.
	offset := self actualOffsetForTimestamp: object.
	self formatter do: [ :each |
		each isCharacter 
			ifTrue: [ stream nextPut: each ] 
			ifFalse: [ 
				each numArgs = 2
					ifTrue: [ self perform: each with: local with: stream ]
					ifFalse: [self perform: each with: local with: stream with: offset ] ] ]
]

{ #category : 'formatters' }
ZTimestampFormat >> format: object secondOn: stream [
	object second printOn: stream
]

{ #category : 'formatters' }
ZTimestampFormat >> format: object secondTwoDigitsOn: stream [
	object second printOn: stream base: 10 length: 2 padded: true
]

{ #category : 'formatters' }
ZTimestampFormat >> format: object timeZoneAbbreviatedLongOn: stream [
	| offset |
	offset := self actualOffsetForTimestamp: object.
	offset isZero
		ifTrue: [ stream << #UTC ]
		ifFalse: [ stream << (self abbreviationForTimeZoneOffset: offset) ]
]

{ #category : 'formatters' }
ZTimestampFormat >> format: object timeZoneAbbreviatedLongOn: stream usingOffset: offset [
	offset isZero
		ifTrue: [ stream << #UTC ]
		ifFalse: [ stream << (self abbreviationForTimeZoneOffset: offset) ]
]

{ #category : 'formatters' }
ZTimestampFormat >> format: object timeZoneAbbreviatedOn: stream [
	| offset |
	offset := self actualOffsetForTimestamp: object.
	offset isZero
		ifTrue: [ stream << #UTC ]
		ifFalse: [ stream << (self abbreviationForTimeZoneOffset: offset) ]
]

{ #category : 'formatters' }
ZTimestampFormat >> format: object timeZoneAbbreviatedOn: stream usingOffset: offset [
	offset isZero
		ifTrue: [ stream << #UTC ]
		ifFalse: [ stream << (self abbreviationForTimeZoneOffset: offset) ]
]

{ #category : 'formatters' }
ZTimestampFormat >> format: object timeZoneOn: stream [
	| offset |
	offset := self actualOffsetForTimestamp: object.
	stream nextPut: (offset positive ifTrue: [ $+ ] ifFalse: [ $- ]).
	offset hours abs
		printOn: stream base: 10 length: 2 padded: true.
	stream nextPut: $:.
	offset minutes
		printOn: stream base: 10 length: 2 padded: true 
]

{ #category : 'formatters' }
ZTimestampFormat >> format: object timeZoneOn: stream usingOffset: offset [
	stream nextPut: (offset positive ifTrue: [ $+ ] ifFalse: [ $- ]).
	offset hours abs
		printOn: stream base: 10 length: 2 padded: true.
	stream nextPut: $:.
	offset minutes
		printOn: stream base: 10 length: 2 padded: true 
]

{ #category : 'formatters' }
ZTimestampFormat >> format: object timeZoneZOn: stream [
	| offset |
	offset := self actualOffsetForTimestamp: object.
	offset isZero
		ifTrue: [ stream nextPut: $Z ]
		ifFalse: [ 
			stream nextPut: (offset positive ifTrue: [ $+ ] ifFalse: [ $- ]).
			offset hours abs
				printOn: stream base: 10 length: 2 padded: true.
			stream nextPut: $:.
			offset minutes
				printOn: stream base: 10 length: 2 padded: true ]
]

{ #category : 'formatters' }
ZTimestampFormat >> format: object timeZoneZOn: stream usingOffset: offset [
	offset isZero
		ifTrue: [ stream nextPut: $Z ]
		ifFalse: [ 
			stream nextPut: (offset positive ifTrue: [ $+ ] ifFalse: [ $- ]).
			offset hours abs
				printOn: stream base: 10 length: 2 padded: true.
			stream nextPut: $:.
			offset minutes
				printOn: stream base: 10 length: 2 padded: true ]
]

{ #category : 'formatters' }
ZTimestampFormat >> format: object weekdayNameAbbreviatedCapitalizedOn: stream [
	stream << ((self weekdayNames at: object dayOfWeek) copyFrom: 1 to: 3)
]

{ #category : 'formatters' }
ZTimestampFormat >> format: object weekdayNameAbbreviatedLowercasedOn: stream [
	stream << ((self weekdayNames at: object dayOfWeek) copyFrom: 1 to: 3) asLowercase 
]

{ #category : 'formatters' }
ZTimestampFormat >> format: object weekdayNameAbbreviatedUppercasedOn: stream [
	stream << ((self weekdayNames at: object dayOfWeek) copyFrom: 1 to: 3) asUppercase 
]

{ #category : 'formatters' }
ZTimestampFormat >> format: object weekdayNameCapitalizedOn: stream [
	stream << (self weekdayNames at: object dayOfWeek)
]

{ #category : 'formatters' }
ZTimestampFormat >> format: object weekdayNameLowercasedOn: stream [
	stream << (self weekdayNames at: object dayOfWeek) asLowercase 
]

{ #category : 'formatters' }
ZTimestampFormat >> format: object weekdayNameUppercasedOn: stream [
	stream << (self weekdayNames at: object dayOfWeek) asUppercase 
]

{ #category : 'formatters' }
ZTimestampFormat >> format: object yearFourDigitsOn: stream [
	object year printOn: stream base: 10 length: 4 padded: true
]

{ #category : 'formatters' }
ZTimestampFormat >> format: object yearFullOn: stream [
	object year printOn: stream base: 10 length: 4 padded: true
]

{ #category : 'formatters' }
ZTimestampFormat >> format: object yearTwoDigitsOn: stream [
	object year \\ 100 printOn: stream base: 10 length: 2 padded: true
]

{ #category : 'accessing' }
ZTimestampFormat >> formatter [
	"Return my compiled formatter, which is based on my specification.
	The is a collection of formatter methods to invoke with optional separator characters"
	
	^ formatter ifNil: [ formatter := self formatterFromElements ]
]

{ #category : 'private' }
ZTimestampFormat >> formatterFromElements [
	^ elements collect: [ :each | 
		each isCharacter 
			ifTrue: [ each ] 
			ifFalse: [
				(each beginsWith: #timeZone)
					ifTrue: [ (#format: , each , #'On:usingOffset:') asSymbol ]
					ifFalse: [ (#format: , each , #On:) asSymbol ] ] ]
]

{ #category : 'initialize-release' }
ZTimestampFormat >> french [
	self monthNames: #( 
		'Janvier' 'Février' 'Mars' 'Avril' 'Mai' 'Juin' 
		'Juillet' 'Août' 'Septembre' 'Octobre' 'Novembre' 'Décembre' ).
	self weekdayNames: #( 
		'Dimanche' 'Lundi' 'Mardi' 'Mercredi' 'Jeudi' 'Vendredi' 'Samedi' )
]

{ #category : 'initialize-release' }
ZTimestampFormat >> german [
	self monthNames: #( 
		'Januar' 'Februar' 'März' 'April' 'Mai' 'Juni' 
		'Juli' 'August' 'September' 'Oktober' 'November' 'Dezember' ).
	self weekdayNames: #( 
		'Sonntag' 'Montag' 'Dienstag' 'Mittwoch' 'Donnerstag' 'Freitag' 'Samstag' )
]

{ #category : 'private' }
ZTimestampFormat >> gmtToLocal: timestamp [
	^ self timezone value
		ifNil: [ timestamp ]
		ifNotNil: [ :actualTimezone | actualTimezone gmtToLocal: timestamp ]
]

{ #category : 'elements' }
ZTimestampFormat >> hour12 [
	self elements add: #hour12
]

{ #category : 'elements' }
ZTimestampFormat >> hour12TwoDigits [
	self elements add: #hour12TwoDigits
]

{ #category : 'elements' }
ZTimestampFormat >> hour24TwoDigits [
	self elements add: #hour24TwoDigits
]

{ #category : 'initialize-release' }
ZTimestampFormat >> initialize [ 
	super initialize.
	self english; createZTimestamp
]

{ #category : 'private' }
ZTimestampFormat >> localToGmt: timestamp [
	^ self timezone value 
		ifNil: [ timestamp ] 
		ifNotNil: [ :actualTimezone | actualTimezone localToGmt: timestamp ]
]

{ #category : 'elements' }
ZTimestampFormat >> minute [
	self elements add: #minute
]

{ #category : 'elements' }
ZTimestampFormat >> minuteTwoDigits [
	self elements add: #minuteTwoDigits
]

{ #category : 'elements' }
ZTimestampFormat >> month [
	self elements add: #month
]

{ #category : 'elements' }
ZTimestampFormat >> monthNameAbbreviatedCapitalized [
	self elements add: #monthNameAbbreviatedCapitalized
]

{ #category : 'elements' }
ZTimestampFormat >> monthNameAbbreviatedLowercased [
	self elements add: #monthNameAbbreviatedLowercased
]

{ #category : 'elements' }
ZTimestampFormat >> monthNameAbbreviatedUppercased [
	self elements add: #monthNameAbbreviatedUppercased
]

{ #category : 'elements' }
ZTimestampFormat >> monthNameCapitalized [
	self elements add: #monthNameCapitalized
]

{ #category : 'elements' }
ZTimestampFormat >> monthNameLowercased [
	self elements add: #monthNameLowercased
]

{ #category : 'elements' }
ZTimestampFormat >> monthNameUppercased [
	self elements add: #monthNameUppercased
]

{ #category : 'accessing' }
ZTimestampFormat >> monthNames [
	^ monthNames
]

{ #category : 'accessing' }
ZTimestampFormat >> monthNames: anObject [
	monthNames := anObject
]

{ #category : 'elements' }
ZTimestampFormat >> monthTwoDigits [
	self elements add: #monthTwoDigits
]

{ #category : 'elements' }
ZTimestampFormat >> nanosecond [
	self elements add: #nanosecond
]

{ #category : 'private' }
ZTimestampFormat >> nextFormatKeyStartingAt: offset [
	^ self class formatKeys
		detect: [ :each | self string: specification contains: each startingAt: offset ]
		ifNone: [ nil ]
]

{ #category : 'private' }
ZTimestampFormat >> offsetForTimeZoneAbbreviation: abbreviation [
	"(TimeZone abbreviated: abbreviation) offset"

	self class abbreviatedTimeZones
		do: [ :each | 
			each first = abbreviation
				ifTrue: [ ^ each second hours ] ].
	self error: 'Cannot find time zone for abbreviation ' , abbreviation asString
]

{ #category : 'parsing' }
ZTimestampFormat >> parse: string [
	"Parse string according to my specification and return an instance as created by my constructor"
	
	^ self readFrom: string readStream
]

{ #category : 'parsers' }
ZTimestampFormat >> parseDayFrom: stream [
	^ #day -> (self readInteger: 1 atLeastFrom: stream)
]

{ #category : 'parsers' }
ZTimestampFormat >> parseDayTwoDigitsFrom: stream [
	^ #day -> (self readInteger: 2 from: stream)
]

{ #category : 'parsers' }
ZTimestampFormat >> parseDayTwoDigitsSpacePaddedFrom: stream [
	^ #day -> (self readInteger: 2 optionalSpaceFrom: stream)
]

{ #category : 'parsers' }
ZTimestampFormat >> parseDaypartLowercasedFrom: stream [
	| part |
	part := stream next: 2.
	self assert: (#('am' 'pm') includes: part).
	^ #daypart -> part asSymbol
]

{ #category : 'parsers' }
ZTimestampFormat >> parseDaypartUppercasedFrom: stream [
	| part |
	part := stream next: 2.
	self assert: (#('AM' 'PM') includes: part).
	^ #daypart -> part asLowercase asSymbol
]

{ #category : 'parsers' }
ZTimestampFormat >> parseHour12From: stream [
	^ #hour -> (self readInteger: 1 atLeastFrom: stream)
]

{ #category : 'parsers' }
ZTimestampFormat >> parseHour12TwoDigitsFrom: stream [
	^ #hour -> (self readInteger: 2 from: stream)
]

{ #category : 'parsers' }
ZTimestampFormat >> parseHour24TwoDigitsFrom: stream [
	^ #hour -> (self readInteger: 2 from: stream)
]

{ #category : 'parsers' }
ZTimestampFormat >> parseMinuteFrom: stream [
	^ #minute -> (self readInteger: 1 atLeastFrom: stream)
]

{ #category : 'parsers' }
ZTimestampFormat >> parseMinuteTwoDigitsFrom: stream [
	^ #minute -> (self readInteger: 2 from: stream)
]

{ #category : 'parsers' }
ZTimestampFormat >> parseMonthFrom: stream [
	^ #month -> (self readInteger: 1 atLeastFrom: stream)
]

{ #category : 'parsers' }
ZTimestampFormat >> parseMonthNameAbbreviatedCapitalizedFrom: stream [
	| abbreviation fullName target |
	abbreviation := stream next: 3.
	target := abbreviation asLowercase capitalized.
	fullName := self monthNames detect: [ :each | 
		self string: each contains: target startingAt: 1 ].
	self assert: (fullName copyFrom: 1 to: 3) capitalized = abbreviation.
	^ #month -> (self monthNames indexOf: fullName)
]

{ #category : 'parsers' }
ZTimestampFormat >> parseMonthNameAbbreviatedLowercasedFrom: stream [
	| abbreviation fullName target |
	abbreviation := stream next: 3.
	target := abbreviation asLowercase capitalized.
	fullName := self monthNames detect: [ :each | 
		self string: each contains: target startingAt: 1 ].
	self assert: (fullName copyFrom: 1 to: 3) asLowercase = abbreviation.
	^ #month -> (self monthNames indexOf: fullName)
]

{ #category : 'parsers' }
ZTimestampFormat >> parseMonthNameAbbreviatedUppercasedFrom: stream [
	| abbreviation fullName target |
	abbreviation := stream next: 3.
	target := abbreviation asLowercase capitalized.
	fullName := self monthNames detect: [ :each | 
		self string: each contains: target startingAt: 1 ].
	self assert: (fullName copyFrom: 1 to: 3) asUppercase = abbreviation.
	^ #month -> (self monthNames indexOf: fullName)
]

{ #category : 'parsers' }
ZTimestampFormat >> parseMonthNameCapitalizedFrom: stream [
	| match |
	match := self readAny: self monthNames sorted from: stream.
	self assert: match notNil.
	^ #month -> (self monthNames indexOf: match)
]

{ #category : 'parsers' }
ZTimestampFormat >> parseMonthNameLowercasedFrom: stream [
	| match |
	match := self 
		readAny: (self monthNames collect: [ :each | each asLowercase ]) sorted 
		from: stream.
	self assert: match notNil.
	^ #month -> (self monthNames indexOf: match capitalized)
]

{ #category : 'parsers' }
ZTimestampFormat >> parseMonthNameUppercasedFrom: stream [
	| match |
	match := self 
		readAny: (self monthNames collect: [ :each | each asUppercase ]) sorted 
		from: stream.
	self assert: match notNil.
	^ #month -> (self monthNames indexOf: match asLowercase capitalized)
]

{ #category : 'parsers' }
ZTimestampFormat >> parseMonthTwoDigitsFrom: stream [
	^ #month -> (self readInteger: 2 from: stream)
]

{ #category : 'parsers' }
ZTimestampFormat >> parseNanosecondFrom: stream [
	| fraction power |
	fraction := 0.
	power := 1.
	[ stream atEnd not and: [ stream peek isDigit ] ]
		whileTrue: [ 
			fraction := fraction * 10 + stream next digitValue.
			power := power * 10 ].
	^ #nanosecond -> (fraction / power * 1e9)
]

{ #category : 'parsers' }
ZTimestampFormat >> parseSecondFrom: stream [
	^ #second -> (self readInteger: 1 atLeastFrom: stream)
]

{ #category : 'parsers' }
ZTimestampFormat >> parseSecondTwoDigitsFrom: stream [
	^ #second -> (self readInteger: 2 from: stream)
]

{ #category : 'parsers' }
ZTimestampFormat >> parseTimeZoneAbbreviatedFrom: stream [
	^ #offset -> (self offsetForTimeZoneAbbreviation: (stream next: 3))
]

{ #category : 'parsers' }
ZTimestampFormat >> parseTimeZoneAbbreviatedLongFrom: stream [
	| offset |
	offset := String streamContents: [ :out |
		[ stream atEnd not and: [ 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' includes: stream peek ] ]
			whileTrue: [ out nextPut: stream next ] ].
	^ #offset -> (self offsetForTimeZoneAbbreviation: offset)
]

{ #category : 'parsers' }
ZTimestampFormat >> parseTimeZoneFrom: stream [
	^ #offset -> (ZTimestamp readTimezoneOffsetFrom: stream) seconds
]

{ #category : 'parsers' }
ZTimestampFormat >> parseTimeZoneZFrom: stream [
	^ #offset -> (ZTimestamp readTimezoneOffsetFrom: stream) seconds
]

{ #category : 'parsers' }
ZTimestampFormat >> parseWeekdayNameAbbreviatedCapitalizedFrom: stream [
	| abbreviation fullName target |
	abbreviation := stream next: 3.
	target := abbreviation asLowercase capitalized.
	fullName := self weekdayNames detect: [ :each | 
		self string: each contains: target startingAt: 1 ].
	self assert: (fullName copyFrom: 1 to: 3) capitalized = abbreviation.
	^ #weekday -> (self weekdayNames indexOf: fullName)
]

{ #category : 'parsers' }
ZTimestampFormat >> parseWeekdayNameAbbreviatedLowercasedFrom: stream [
	| abbreviation fullName target |
	abbreviation := stream next: 3.
	target := abbreviation asLowercase capitalized.
	fullName := self weekdayNames detect: [ :each | 
		self string: each contains: target startingAt: 1 ].
	self assert: (fullName copyFrom: 1 to: 3) asLowercase = abbreviation.
	^ #weekday -> (self weekdayNames indexOf: fullName)
]

{ #category : 'parsers' }
ZTimestampFormat >> parseWeekdayNameAbbreviatedUppercasedFrom: stream [
	| abbreviation fullName target |
	abbreviation := stream next: 3.
	target := abbreviation asLowercase capitalized.
	fullName := self weekdayNames detect: [ :each | 
		self string: each contains: target startingAt: 1 ].
	self assert: (fullName copyFrom: 1 to: 3) asUppercase = abbreviation.
	^ #weekday -> (self weekdayNames indexOf: fullName)
]

{ #category : 'parsers' }
ZTimestampFormat >> parseWeekdayNameCapitalizedFrom: stream [
	| match |
	match := self readAny: self weekdayNames sorted from: stream.
	self assert: match notNil.
	^ #weekday -> (self weekdayNames indexOf: match)
]

{ #category : 'parsers' }
ZTimestampFormat >> parseWeekdayNameLowercasedFrom: stream [
	| match |
	match := self 
		readAny: (self weekdayNames collect: [ :each | each asLowercase ]) sorted 
		from: stream.
	self assert: match notNil.
	^ #weekday -> (self weekdayNames indexOf: match capitalized)
]

{ #category : 'parsers' }
ZTimestampFormat >> parseWeekdayNameUppercasedFrom: stream [
	| match |
	match := self 
		readAny: (self weekdayNames collect: [ :each | each asUppercase ]) sorted 
		from: stream.
	self assert: match notNil.
	^ #weekday -> (self weekdayNames indexOf: match asLowercase capitalized)
]

{ #category : 'parsers' }
ZTimestampFormat >> parseYearFourDigitsFrom: stream [
	^ #year -> (self readInteger: 4 from: stream)
]

{ #category : 'parsers' }
ZTimestampFormat >> parseYearFullFrom: stream [
	| sign |
	sign := 1.
	stream peek = $-
		ifTrue: [ 
			stream next.
			sign := -1 ].
	^ #year -> (sign * (self readInteger: 4 atLeastFrom: stream))
]

{ #category : 'parsers' }
ZTimestampFormat >> parseYearTwoDigitsFrom: stream [
	^ #year -> (2000 + (self readInteger: 2 from: stream))
]

{ #category : 'accessing' }
ZTimestampFormat >> parser [
	"Return my compiled parser, which is based on my specification.
	The is a collection of parser methods to invoke with optional separator characters"

	^ parser ifNil: [ parser := self parserFromElements ]
]

{ #category : 'private' }
ZTimestampFormat >> parserFromElements [
	^ elements collect: [ :each | 
		 each isCharacter
			ifTrue: [ each ]
			ifFalse: [ (#parse , each capitalized , #From:) asSymbol ] ]
]

{ #category : 'printing' }
ZTimestampFormat >> printOn: stream [
	super printOn: stream.
	stream nextPut: $(.
	stream << self specification.
	stream nextPut: $)
]

{ #category : 'private' }
ZTimestampFormat >> readAny: strings from: stream [
	"Read any of the sorted collection strings from stream, or nil"
	
	| candidate matchCount |
	candidate := 1.
	matchCount := 0.
	[
		(strings at: candidate) size = matchCount 
			ifTrue: [ ^ strings at: candidate ].
		(stream atEnd or: [ candidate > strings size ])
			ifTrue: [ ^ nil ].
		(((strings at: candidate) at: matchCount + 1) = stream peek)
			ifTrue: [
				stream next.
				matchCount := matchCount + 1 ]
			ifFalse: [
				candidate := candidate + 1.
				(candidate <= strings size
					and: [ (1 to: matchCount) allSatisfy: [ :each | 
								((strings at: candidate - 1) at: each) = ((strings at: candidate) at: each) ] ])
					ifFalse: [ ^ nil ] ]
	] repeat
]

{ #category : 'parsing' }
ZTimestampFormat >> readFrom: stream [
	"Parse stream according to my specification and return an instance as created by my constructor"

	| elementValues |
	elementValues := SmallDictionary new.
	self parser do: [ :each |
		each isCharacter 
			ifTrue: [ self assert: stream next = each ]
			ifFalse: [ elementValues add: (self perform: each with: stream) ] ].
	^ self createInstanceFrom: elementValues
]

{ #category : 'private' }
ZTimestampFormat >> readInteger: numberOfDigits atLeastFrom: stream [
	"Parse and return a decimal number of at least numberOfDigits from stream.
	Continue reading until a non digit or the end of stream is reached.
	Fail if that is not possible"

	| integer |
	integer := 0.
	numberOfDigits timesRepeat: [ | char |
		char := stream next.
		self assert: ('0123456789' includes: char).
		integer := (integer * 10) + char digitValue ].
	[ stream atEnd not and: [ stream peek isDigit ] ] whileTrue: [
		integer := (integer * 10) + stream next digitValue ].
	^ integer
]

{ #category : 'private' }
ZTimestampFormat >> readInteger: numberOfDigits from: stream [
	"Parse and return a decimal number of numberOfDigits from stream.
	Fail if that is not possible"

	| integer |
	integer := 0.
	numberOfDigits timesRepeat: [ | char |
		char := stream next.
		self assert: ('0123456789' includes: char).
		integer := (integer * 10) + char digitValue ].
	^ integer
]

{ #category : 'private' }
ZTimestampFormat >> readInteger: numberOfDigits optionalSpaceFrom: stream [
	"Parse and return a decimal number of numberOfDigits from stream.
	There can be one optional space instead of a digit at the beginning.
	Fail if that is not possible"

	^ stream peek = $ 
		ifTrue: [ 
			stream next. 
			self readInteger: numberOfDigits - 1 from: stream ]
		ifFalse: [
			self readInteger: numberOfDigits from: stream ]
]

{ #category : 'elements' }
ZTimestampFormat >> second [
	self elements add: #second
]

{ #category : 'elements' }
ZTimestampFormat >> secondTwoDigits [
	self elements add: #secondTwoDigits
]

{ #category : 'accessing' }
ZTimestampFormat >> specification [
	^ specification ifNil: [ specification := self specificationFromElements ]
]

{ #category : 'initialize-release' }
ZTimestampFormat >> specification: exampleString [
	"Initialize me based on exampleString.
	See my class comment and class side examples."
	
	specification := exampleString.
	self compileSpecification
]

{ #category : 'private' }
ZTimestampFormat >> specificationFromElements [
	| inverseFormats |
	inverseFormats := (self class formatSpecifications 
		pairsCollect: [ :key :value | value -> key ]) asDictionary.
	^ String streamContents: [ :out |
		elements do: [ :each |
			out nextPutAll: (inverseFormats at: each ifAbsent: [ each asString ]) ] ]
]

{ #category : 'private' }
ZTimestampFormat >> string: string contains: subString startingAt: offset [
	subString doWithIndex: [ :each :index |
		offset + index - 1 <= string size 
			ifFalse: [ ^ false ].
		(string at: offset + index - 1) = each
			ifFalse: [ ^ false ] ].
	^ true
]

{ #category : 'elements' }
ZTimestampFormat >> timeZone [
	self elements add: #timeZone
]

{ #category : 'elements' }
ZTimestampFormat >> timeZoneAbbreviated [
	self elements add: #timeZoneAbbreviated
]

{ #category : 'elements' }
ZTimestampFormat >> timeZoneAbbreviatedLong [
	self elements add: #timeZoneAbbreviatedLong
]

{ #category : 'elements' }
ZTimestampFormat >> timeZoneZ [
	self elements add: #timeZoneZ
]

{ #category : 'accessing' }
ZTimestampFormat >> timezone [
	^ timezone
]

{ #category : 'accessing' }
ZTimestampFormat >> timezone: anObject [
	"Set the optional timezone that I should use to convert UTC/GMT/Zulu timestamps 
	into local time representations and vice versa if none is specified.
	The timezone object will be sent #value before use.
	When the value is nil, no conversions will be done.
	The returned value will be sent #offsetForTimestamp: when used."
	
	timezone := anObject
]

{ #category : 'initialize-release' }
ZTimestampFormat >> useCurrentTimezone [
	"Configure me to use the timezone set in the ZCurrentTimezone dynamic variable"
	
	self timezone: ZCurrentTimezone
]

{ #category : 'elements' }
ZTimestampFormat >> weekdayNameAbbreviatedCapitalized [
	self elements add: #weekdayNameAbbreviatedCapitalized
]

{ #category : 'elements' }
ZTimestampFormat >> weekdayNameAbbreviatedLowercased [
	self elements add: #weekdayNameAbbreviatedLowercased
]

{ #category : 'elements' }
ZTimestampFormat >> weekdayNameAbbreviatedUppercased [
	self elements add: #weekdayNameAbbreviatedUppercased
]

{ #category : 'elements' }
ZTimestampFormat >> weekdayNameCapitalized [
	self elements add: #weekdayNameCapitalized
]

{ #category : 'elements' }
ZTimestampFormat >> weekdayNameLowercased [
	self elements add: #weekdayNameLowercased
]

{ #category : 'elements' }
ZTimestampFormat >> weekdayNameUppercased [
	self elements add: #weekdayNameUppercased
]

{ #category : 'accessing' }
ZTimestampFormat >> weekdayNames [
	^ weekdayNames
]

{ #category : 'accessing' }
ZTimestampFormat >> weekdayNames: anObject [
	weekdayNames := anObject
]

{ #category : 'elements' }
ZTimestampFormat >> yearFourDigits [
	self elements add: #yearFourDigits
]

{ #category : 'elements' }
ZTimestampFormat >> yearFull [
	self elements add: #yearFull
]

{ #category : 'elements' }
ZTimestampFormat >> yearTwoDigits [
	self elements add: #yearTwoDigits
]
