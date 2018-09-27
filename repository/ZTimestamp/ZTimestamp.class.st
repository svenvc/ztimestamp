"
I am ZTimestamp.
I am a Magnitude.
I represent a point in time, a combination of a date and a time.

I am an alternative for DateAndTime and TimeStamp.
I have second precision and live in the UTC/GMT/Zulu timezone.
I use ISO/International conventions and protocols only. 
I support some essential arithmetic.

I have an efficient internal representation:

	jnd - the julian day number <SmallInteger>
	secs - the number of seconds since midnight, the beginning of the day <SmallInteger>

Examples:

	ZTimestamp now.
	ZTimestamp fromString: '1969-07-20T20:17:40Z'.

There is some compatibility with existing, standard Chronology objects.
I correctly parse representations with a timezone designator
and can print a representation in arbitrary timezones. 

	(ZTimestamp fromString: DateAndTime now truncated printString) localPrintString.
"
Class {
	#name : #ZTimestamp,
	#superclass : #Magnitude,
	#instVars : [
		'jdn',
		'secs'
	],
	#classVars : [
		'ClockEpoch',
		'ClockTimezoneOffset',
		'UnixEpoch',
		'Zero'
	],
	#category : 'ZTimestamp'
}

{ #category : #'instance creation' }
ZTimestamp class >> @ stringOrStream [
	"Shortcut/convenience method to create a ZTimetamp instance by parsing a string or stream"
	
	^ self readFrom: stringOrStream readStream
]

{ #category : #private }
ZTimestamp class >> clockEpoch [
	"Return the epoch of the clock that we use as an instance (cached), see #now
	This is expressed in UTC regardless of #clockSeconds, see #clockTimezoneOffset"
	
	^ ClockEpoch ifNil: [
		ClockEpoch := self year: 1901 month: 1 day: 1 ]
]

{ #category : #private }
ZTimestamp class >> clockSeconds [
	"Return the total seconds count of the clock that we use as an Integer since the #clockEpoch, 
	see #now. This can be in UTC or not, then it will be compensated using #clockTimezoneOffset"

	^ Time totalSeconds
]

{ #category : #private }
ZTimestamp class >> clockTimezoneOffset [
	"Return the timezone offset of the clock that we use as an Integer seconds (cached), see #now.
	In a 3.0 image, which implements #primUTCMicrosecondsClock, Time>>#totalSeconds is UTC,
	where in 2.0 it is in local time."

	^ ClockTimezoneOffset
		ifNil: [ 
			ClockTimezoneOffset := (Time respondsTo: #primUTCMicrosecondsClock)
				ifTrue: [ 0 ]
				ifFalse: [ DateAndTime localTimeZone offset asSeconds ] ]
]

{ #category : #private }
ZTimestamp class >> dateError: message [
	(Smalltalk at: #DateError ifAbsent: [ Error ]) signal: message
]

{ #category : #accessing }
ZTimestamp class >> epoch [
	"Return the epoch of my instances, the point in time from which they start counting, as an instance"
	
	^ self zero
]

{ #category : #private }
ZTimestamp class >> fromClockSeconds: seconds [
	"Create and return a new instance from a specific number of seconds since our clock epoch, see #now"
	
	^ self new
		jdn: self clockEpoch julianDayNumber + (seconds // 86400)
		secs: self clockEpoch secondsSinceMidnight + (seconds \\ 86400)
	
]

{ #category : #'instance creation' }
ZTimestamp class >> fromJulianDate: julianDate [
	"Create and return a new ZTimestamp instance from the scientific Julian Date, a Float number of Julian Days"
	
	^ self new
		jdn: julianDate truncated
		secs: (julianDate fractionPart * 86400) truncated
		
]

{ #category : #ston }
ZTimestamp class >> fromSton: stonReader [
	"Read our ISO representation"
	
	^ self readFrom: stonReader parseListSingleton readStream
]

{ #category : #'instance creation' }
ZTimestamp class >> fromString: string [
	"Parse and return an instance from a flexible ISO 8601 string representation, see #readFrom:" 

	^ self readFrom: string readStream
]

{ #category : #'instance creation' }
ZTimestamp class >> fromString: string format: formatSpecification [
	"Parse and return an instance from the string representation 
	according to formatSpecification, see #readFrom:format:" 

	^ self readFrom: string readStream format: formatSpecification
]

{ #category : #'instance creation' }
ZTimestamp class >> fromUnixTime: integer [
	"Create and return a new ZTimestamp from the integer number of seconds since the Unix or POSIX epoch"
	
	^ self unixEpoch + integer seconds

]

{ #category : #'class initialization' }
ZTimestamp class >> initialize [
	Smalltalk addToStartUpList: self.
]

{ #category : #accessing }
ZTimestamp class >> jdnFromYear: year month: month day: day [
	"Compute and return the Julian Day Number from the Gregorian Calender date described by year, month and day.
	See http://en.wikipedia.org/wiki/Julian_date#Converting_Gregorian_calendar_date_to_Julian_Day_Number"
	 
	| a y m |
	self validateYear: year month: month day: day.
	a := (14 - month) // 12.
	y := year + 4800 - a.
	m := month + (12 * a) - 3.
	^ day 
		+ (((153 * m) + 2) // 5) 
		+ (365 * y)
		+ (y // 4)
		- (y // 100)
		+ (y // 400)
		- 32045
]

{ #category : #accessing }
ZTimestamp class >> localTimeZone [
	"Return the current machine's local timezone offset as a Duration"
	
	^ DateAndTime localTimeZone
]

{ #category : #'instance creation' }
ZTimestamp class >> now [
	"Create and return a new ZTimestamp equal to the current system time"
	
	^ self fromClockSeconds: (self clockSeconds - self clockTimezoneOffset)
]

{ #category : #'instance creation' }
ZTimestamp class >> readFrom: stream [
	"Parse a ISO 8601 representation from stream, in the format
	year[-]month[-]day[T]hour[:]minute[:]second[[+|-]hh[:][mm]]
	where the whole part after T as well as the TZ offset is optional.
	TZ offset can be Z, all separators can be any non digit.
	Supports reduced accuracy from least to most significant in time."

	| negative year month day hour minute second offset |
	negative := stream peekFor: $-.
	year := self readInteger: 4 from: stream.
	negative ifTrue: [ year := year negated ].
	self readOptionalSeparatorExpecting: '0123456789' from: stream.
	month := self readInteger: 2 from: stream.
	self readOptionalSeparatorExpecting: '0123456789' from: stream.
	day := self readInteger: 2 from: stream.
	hour := minute := second := offset := 0.
	(self readOptionalSeparatorExpecting: '0123456789' from: stream)
		ifTrue: [
			hour := self readInteger: 2 from: stream.
			(self readOptionalSeparatorExpecting: '0123456789' from: stream)
				ifTrue: [
					minute := self readInteger: 2 from: stream.
					(self readOptionalSeparatorExpecting: '0123456789' from: stream)
						ifTrue: [ second := self readInteger: 2 from: stream ] ]. 
			offset := self readTimezoneOffsetFrom: stream ].
	^ self 
		year: year
		month: month
		day: day
		hour: hour
		minute: minute
		second: second
		offset: (offset = 0 ifTrue: [ 0 ] ifFalse: [ offset seconds ])
]

{ #category : #'instance creation' }
ZTimestamp class >> readFrom: stream format: formatSpecification [
	"Parse a representation from stream, according to formatSpecification
	and return an instance of me. See ZTimestampFormat for details."

	^ (ZTimestampFormat fromString: formatSpecification)
			readFrom: stream 
]

{ #category : #private }
ZTimestamp class >> readInteger: numberOfDigits from: stream [
	"Parse and return a decimal number of numberOfDigits from stream.
	Fail if that is not possible"

	| integer |
	integer := 0.
	numberOfDigits timesRepeat: [ | char |
		char := stream next.
		('0123456789' includes: char)
			ifTrue: [ integer := (integer * 10) + char digitValue ]
			ifFalse: [ self error: 'Decimal digit expected' ] ].
	^ integer
]

{ #category : #private }
ZTimestamp class >> readOptionalSeparatorExpecting: nonSeparators from: stream [
	"Read an optional separator (all but nonSeparators) from stream.
	Return true when a nonSeparator is peeked, false otherwise.
	Note that EOF returns false."

	(nonSeparators includes: stream peek)
		ifFalse: [ stream next notNil ].
	^ nonSeparators includes: stream peek
]

{ #category : #private }
ZTimestamp class >> readTimezoneOffsetFrom: stream [
	"Read and return an optional timezone offset in the form of 
	[+|-]hh[separator][mm] from stream as an Integer seconds.
	If there is no offset, just return 0"

	| sign hour minute |
	(stream atEnd or: [ stream peekFor: $Z ]) ifTrue: [ ^ 0 ].
	^ ('+-' includes: stream peek)
		ifTrue: [
			sign := stream next = $- ifTrue: [ -1 ] ifFalse: [ 1 ].
			hour := self readInteger: 2 from: stream.
			minute := (self readOptionalSeparatorExpecting: '0123456789' from: stream)
				ifTrue: [  self readInteger: 2 from: stream ]
				ifFalse: [ 0 ].
			sign * ((hour * 3600) + (minute * 60)) ]
		ifFalse: [ 0 ]

]

{ #category : #'system startup' }
ZTimestamp class >> startUp [
	"Clear the cached clock timezone offset"
	
	ClockTimezoneOffset := nil
]

{ #category : #'instance creation' }
ZTimestamp class >> today [
	"Create and return a new ZTimestamp equal to the current date"
	
	^ self now asBeginOfDay
]

{ #category : #accessing }
ZTimestamp class >> unixEpoch [
	"Return the Unix or POSIX epoch as a ZTimestamp"
	
	^ UnixEpoch 
		ifNil: [ UnixEpoch := self year: 1970 month: 1 day: 1 ]
]

{ #category : #private }
ZTimestamp class >> validateYear: year month: month day: day [
	| daysInMonth message |
	year isInteger
		ifFalse: [ self dateError: 'Year should be an integer, not ' , year printString ].
	(month isInteger and: [ month between: 1 and: 12 ])
		ifFalse: [ self dateError: 'Month should be an integer between 1 and 12, not ' , month printString ].
	daysInMonth := Month daysInMonth: month forYear: year.
	(day isInteger and: [ day between: 1 and: daysInMonth ])
		ifFalse: [ 
			message := 'Day should be an integer between 1 and {1}, the number of days in month {2} of year {3}, not {4}' 
				format: { daysInMonth. month. year. day printString }.
			self dateError: message ]
]

{ #category : #accessing }
ZTimestamp class >> withJdn: jdn dayMonthYearDo: block [
	"Return the value of executing block with the Gregorian Calender day, month and year as arguments,
	as computed from my Julian Day Number, jdn.
	See http://en.wikipedia.org/wiki/Julian_date#Gregorian_calendar_from_Julian_day_number"
	
	| j g dg c dc b db a da y m d |
	j := jdn + 32044.
	g := j // 146097.
	dg := j \\ 146097.
	c := ((dg // 36524) + 1) * 3 // 4.
	dc := dg - (c * 36524).
	b := dc // 1461.
	db := dc \\ 1461.
	a := ((db // 365) + 1) * 3 // 4.
	da := db - (a * 365).
	y := (g * 400) + (c * 100) + (b * 4) + a.
	m := ((((da * 5) + 308)) // 153) - 2.
	d := da - ((m + 4) * 153 // 5) + 122.
	^ block
		value: d + 1
		value: ((m + 2) \\ 12) + 1
		value: (y - 4800 + ((m + 2) // 12)) 
]

{ #category : #accessing }
ZTimestamp class >> withNowDo: block [
	"Evaluate block with 2 arguments: ZTimestamp now and the residual microseconds.
	Return the value of block. Works only on Pharo 3.0 and higher."
	
	"self withNowDo: [ :timestamp :microseconds | { timestamp. microseconds } ]"
	
	| microsecondClockValue totalSeconds |
	microsecondClockValue := Time microsecondClockValue.
	totalSeconds := microsecondClockValue // 1e6.
	^ block 
		cull: (self fromClockSeconds: totalSeconds - self clockTimezoneOffset)
		cull: microsecondClockValue - (totalSeconds * 1e6)
]

{ #category : #'instance creation' }
ZTimestamp class >> year: year month: month day: day [
	"Create and return a new ZTimestamp for the Gregorian calendar date described by year, month and date"
	
	^ self new
		jdn: (self jdnFromYear: year month: month day: day)
		secs: 0
]

{ #category : #'instance creation' }
ZTimestamp class >> year: year month: month day: day hour: hour minute: minute second: second [
	"Create and return a new ZTimestamp for the Gregorian calendar date described by year, month and date
	and the Civil time of day on that date described by hour, minute and second"

	^ self new
		jdn: (self jdnFromYear: year month: month day: day)
		secs: (hour * 3600) + (minute * 60) + second
]

{ #category : #'instance creation' }
ZTimestamp class >> year: year month: month day: day hour: hour minute: minute second: second offset: offset [
	"Create and return a new ZTimestamp for the Gregorian calendar date described by year, month and date
	and the Civil time of day on that date described by hour, minute and second.
	If offset is non zero, the result is shifted accordingly."

	| timestamp |
	(timestamp := self new)
		jdn: (self jdnFromYear: year month: month day: day)
		secs: (hour * 3600) + (minute * 60) + second.
	offset isZero 
		ifFalse: [ timestamp := timestamp - offset ].
	^ timestamp 
]

{ #category : #accessing }
ZTimestamp class >> zero [
	"Return my zero instance, the point in time from which we start counting, see #epoch"

	^ Zero 
		ifNil: [ 
			Zero :=  self new jdn: 0 secs: 0 ]
]

{ #category : #arithmetic }
ZTimestamp >> + operand [
	"Return a new ZTimestamp that is the result of adding
	the operand considered as a Duration to the receiver"
	
	^ self class new
		jdn: jdn
		secs: secs + operand asDuration asSeconds
]

{ #category : #arithmetic }
ZTimestamp >> - operand [
	"For ZTimestamp compatible operands, return a new Duration 
	equal to the difference between the reveiver and the operand.
	Else return a new ZTimestamp that is the result of subtracting 
	the operand considered as a Duration from the receiver.
	Implemented using double dispatch."
	
	^ operand subtractFromTimestamp: self
]

{ #category : #testing }
ZTimestamp >> < aZTimestamp [
	"Answer true when aZTimestamp is strictly later than me, false otherwise.
	Part of the Magnitude protocol"
	
	^ jdn = aZTimestamp julianDayNumber
		ifTrue: [ secs < aZTimestamp secondsSinceMidnight ]
		ifFalse: [ jdn < aZTimestamp julianDayNumber ]
]

{ #category : #testing }
ZTimestamp >> = aZTimestamp [
	"Answer true when aZTimestamp equals the receiver, false otherwise.
	Part of the Magnitude protocol"
	
	self == aZTimestamp ifTrue: [ ^ true ].
	self class = aZTimestamp class ifFalse: [ ^ false ].
	^ jdn = aZTimestamp julianDayNumber
		and: [ secs = aZTimestamp secondsSinceMidnight ]
]

{ #category : #converting }
ZTimestamp >> asBeginOfDay [
	"Return a timestamp at the begin of the day that I represent"
	
	^ self class new
		jdn: jdn secs: 0 
]

{ #category : #converting }
ZTimestamp >> asDate [
	"Convert the receiver to a Date"
	
	^ self asDateAndTime asDate
]

{ #category : #converting }
ZTimestamp >> asDateAndTime [ 
	"Convert the receiver to a DateAndTime.
	Note that I am in the UTC/GMT/Zulu timezone and have second precision"
	
	^ DateAndTime new
		setJdn: jdn 
		seconds: secs 
		nano: 0 
		offset: self offset
]

{ #category : #converting }
ZTimestamp >> asEndOfDay [
	"Return a timestamp at the end of the day that I represent"
	
	^ self class new
		jdn: jdn secs: 86399
]

{ #category : #converting }
ZTimestamp >> asMonth [
	"Convert the receiver to a Month"
	
	^ self asDateAndTime asMonth
]

{ #category : #converting }
ZTimestamp >> asTime [
	"Convert the receiver to a Time in the current day.
	Note that I have second precision"
	
	^ Time seconds: secs
]

{ #category : #converting }
ZTimestamp >> asUnixTime [
	"Return the Integer number of seconds since the Unix or POSIX epoch."
	
	^ (self - self class unixEpoch) asSeconds
]

{ #category : #converting }
ZTimestamp >> asWeek [
	"Convert the receiver to a Week"
	
	^ self asDateAndTime asWeek
]

{ #category : #converting }
ZTimestamp >> asYear [
	"Convert the receiver to a Year"
	
	^ self asDateAndTime asYear
]

{ #category : #converting }
ZTimestamp >> asZTimestamp [
	"Convert the receiver to a ZTimestamp."
	
	^ self
]

{ #category : #accessing }
ZTimestamp >> day [
	"Return the day of the year of the receiver, according to the Gregorian calendar, a number between 1 and 365"
	
	^ self dayOfYear
]

{ #category : #accessing }
ZTimestamp >> dayMonthYearDo: block [
	"Compute and return the Julian Day Number from the Gregorian Calender date described by year, month and day.
	See http://en.wikipedia.org/wiki/Julian_date#Converting_Gregorian_calendar_date_to_Julian_Day_Number"

	^ self class 
		withJdn: jdn dayMonthYearDo: block
]

{ #category : #accessing }
ZTimestamp >> dayOfMonth [
	"Return the day of the month of the receiver, according to the Gregorian calendar, a number between 1 and 31"

	^ self dayMonthYearDo: [ :day :month :year | day ]
]

{ #category : #accessing }
ZTimestamp >> dayOfWeek [
	"Return the day of the week of the receiver, according to the Gregorian calendar, a number between 1 and 7.
	1 = Sunday, 2 = Monday, .. , 7 = Saturday."

	^ ((jdn + 1) \\ 7) + 1
]

{ #category : #accessing }
ZTimestamp >> dayOfWeekName [
	"Return the English name of the day of the week of the receiver, according to the Gregorian calendar, a Symbol"

	^ #(Sunday Monday Tuesday Wednesday Thursday Friday Saturday) at: self dayOfWeek
]

{ #category : #accessing }
ZTimestamp >> dayOfYear [
	"Return the day of the year of the receiver, according to the Gregorian calendar, a number between 1 and 365"

	^ self dayMonthYearDo: [ :day :month :year | | monthStart |
		monthStart := #(1 32 60 91 121 152 182 213 244 274 305 335) at: month.
		(month > 2 and: [ Year isLeapYear: year ])
			ifTrue: [ monthStart + day ]
			ifFalse: [ monthStart + day - 1 ] ]
]

{ #category : #printing }
ZTimestamp >> format: formatSpecification [
	"Return a string representation of me according to formatSpecification.
	See ZTimestampFormat for details."
	
	^ (ZTimestampFormat fromString: formatSpecification)
			format: self
]

{ #category : #printing }
ZTimestamp >> format: formatSpecification on: stream [
	"Write a string representation of me according to formatSpecification on stream.
	See ZTimestampFormat for details."

	^ (ZTimestampFormat fromString: formatSpecification)
			format: self on: stream
]

{ #category : #hash }
ZTimestamp >> hash [
	"Return an Integer hash value for the receiver.
	Part of the Magnitude protocl"
	
	^ jdn hashMultiply bitXor: secs
]

{ #category : #accessing }
ZTimestamp >> hour [
	"Return the number of hours in the receiver, according to Civil time, a number between 0 and 23"

	^ (secs \\ 86400) // 3600
]

{ #category : #accessing }
ZTimestamp >> hours [
	"Return the number of hours in the receiver, according to Civil Time, a number between 0 and 23"

	^ self hour
]

{ #category : #'initialize-release' }
ZTimestamp >> jdn: julianDayNumber secs: secondsSinceMidnight [
	"Initialize the receiver with julianDayNumber and secondsSinceMidnight,
	then normalize so that secondsSinceMidnight is within the expected range"
	
	jdn := julianDayNumber.
	secs := secondsSinceMidnight.
	self normalize
]

{ #category : #accessing }
ZTimestamp >> julianDate [
	"Return the scientific Julian Date, a Float number of Julian Days"
	
	^ jdn + (secs / 86400.0)
]

{ #category : #accessing }
ZTimestamp >> julianDayNumber [
	"Return the Julian Day Number of the receiver, an Integer number of days since the epoch"
	
	^ jdn
]

{ #category : #printing }
ZTimestamp >> localPrintString [
	"Convencience method to convert the receiver in an ISO 8601 representation using the local timezone"

	^ String streamContents: [ :stream |
		self printLocalOn: stream ]
]

{ #category : #accessing }
ZTimestamp >> minute [
	"Return the number of minutes in the receiver after full hours have been removed, 
	according to Civil Time, a number between 0 and 59"

	^ (secs \\ 3600) // 60
]

{ #category : #accessing }
ZTimestamp >> minutes [
	"Return the number of minutes in the receiver after full hours have been removed, 
	according to Civil Time, a number between 0 and 59"

	^ self minute
]

{ #category : #accessing }
ZTimestamp >> month [
	"Return the month of the receiver, according to the Gregorian calendar, a number between 1 and 12"

	^ self dayMonthYearDo: [ :day :month :year | month ]
]

{ #category : #accessing }
ZTimestamp >> monthIndex [
	"Return the month of the receiver, according to the Gregorian calendar, a number between 1 and 12"

	^ self month
]

{ #category : #accessing }
ZTimestamp >> monthName [
	"Return the English name of the month of the receiver, 
	according to the Gregorian calendar, a Symbol"

	^ #(
		January February March 
		April May June 
		July August September 
		October November December ) at: self monthIndex
]

{ #category : #accessing }
ZTimestamp >> nanoSecond [
	"For compatibility: make clear that I have second precision and no fractions of a second."
	 
	^ 0
]

{ #category : #'initialize-release' }
ZTimestamp >> normalize [
	"Normalize the receiver such that 0 <= secs < 86400"
	 
	(secs between: 0 and: 86399)
		ifFalse: [
			jdn := jdn + (secs // 86400).
			secs := secs \\ 86400 ]
]

{ #category : #accessing }
ZTimestamp >> offset [
	"For compatibility: make clear that my timezone offset is zero.
	I am always in the UTC, GMT or Zulu timezone"
	 
	^ Duration zero
]

{ #category : #printing }
ZTimestamp >> printLocalOn: stream [
	"Print the receiver on stream in ISO 8601 extended format in the local timezone"
	
	self 
		printOn: stream 
		format: #($- $T $: nil) 
		timezone: self class localTimeZone offset
]

{ #category : #printing }
ZTimestamp >> printOn: stream [
	"Print the receiver on stream in ISO 8601 extended format"
	
	self 
		printOn: stream 
		format: #($- $T $: $Z)
]

{ #category : #printing }
ZTimestamp >> printOn: stream format: format [
	"Print the receiver on stream using format, following ISO 8601.
	Format defines 4 characters to use:
	#(dateSeparator dateTimeSeparator timeSeparator timeZoneIndicator)
	Each can be nil to skip that separator"
	
	self dayMonthYearDo: [ :day :month :year |
		year < 0
			ifTrue: [ 
				stream nextPut: $-. 
				year abs printOn: stream base: 10 length: 4 padded: true  ]
			ifFalse: [ 
				year printOn: stream base: 10 length: 4 padded: true ].
		(format at: 1) ifNotNil: [ :separator | stream nextPut: separator ].
		month printOn: stream base: 10 length: 2 padded: true.
		(format at: 1) ifNotNil: [ :separator | stream nextPut: separator ].
		day printOn: stream base: 10 length: 2 padded: true ].
	(format at: 2) ifNotNil: [ :separator | stream nextPut: separator ].
	self hour printOn: stream base: 10 length: 2 padded: true.
	(format at: 3) ifNotNil: [ :separator | stream nextPut: separator ].
	self minute printOn: stream base: 10 length: 2 padded: true.
	(format at: 3) ifNotNil: [ :separator | stream nextPut: separator ].
	self second printOn: stream base: 10 length: 2 padded: true.
	(format at: 4) ifNotNil: [ :separator | stream nextPut: separator ]
]

{ #category : #printing }
ZTimestamp >> printOn: stream format: format timezone: timezone [
	"Print an ISO representation in timezone and adding it as [+|-]HH:MM"

	(self + timezone asDuration) printOn: stream format: format.
	stream nextPut: (timezone positive ifTrue: [ $+ ] ifFalse: [ $- ]).
	timezone hours abs printOn: stream base: 10 length: 2 padded: true.
	(format at: 3) ifNotNil: [ :separator | stream nextPut: separator ].
	timezone minutes printOn: stream base: 10 length: 2 padded: true
]

{ #category : #accessing }
ZTimestamp >> second [
	"Return the number of seconds in the receiver after full hours and minutes have been removed, 
	according to Civil Time, a number between 0 and 59"

	^ secs \\ 60
]

{ #category : #accessing }
ZTimestamp >> seconds [
	"Return the number of seconds in the receiver after full hours and minutes have been removed, 
	according to Civil Time, a number between 0 and 59"

	^ self second
]

{ #category : #accessing }
ZTimestamp >> secondsSinceMidnight [
	"Return the seconds since midnight since the beginning of the Julian Day of the receiver, 
	an Integer between 0 and 86399, inclusive"
	
	^ secs
]

{ #category : #accessing }
ZTimestamp >> secondsSinceMidnightUTC [
	"Return the seconds since midnight since the beginning of the Julian Day of the receiver, 
	an Integer between 0 and 86399, inclusive - we're always in UTC"
	
	^ secs
]

{ #category : #ston }
ZTimestamp >> stonContainSubObjects [ 
	^ false
]

{ #category : #ston }
ZTimestamp >> stonOn: stonWriter [
	"Use an ISO representation with all details"
	
	stonWriter writeObject: self listSingleton: 
		(String new: 20 streamContents: [ :stream |
			self printOn: stream ])
]

{ #category : #arithmetic }
ZTimestamp >> subtractDuration: duration [
	"Part of the double dispatch implementation of ZTimestamp>>#-"
	
	^ self + duration negated
]

{ #category : #arithmetic }
ZTimestamp >> subtractFromTimestamp: timestamp [
	"Part of the double dispatch implementation of ZTimestamp>>#-"
	
	^ timestamp subtractTimestamp: self
]

{ #category : #arithmetic }
ZTimestamp >> subtractTimestamp: timestamp [
	"Part of the double dispatch implementation of ZTimestamp>>#-"
	
	^ Duration seconds: 
			((jdn - timestamp julianDayNumber) * 86400) 
			+ (secs - timestamp secondsSinceMidnight)
]

{ #category : #accessing }
ZTimestamp >> year [
	"Return the year of the receiver, according to the Gregorian calendar, an Integer"

	^ self dayMonthYearDo: [ :day :month :year | year ]
]
