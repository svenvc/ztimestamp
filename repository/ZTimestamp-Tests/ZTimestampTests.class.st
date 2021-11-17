"
I am ZTimestampTests, a test suite for ZTimestamp.
"
Class {
	#name : #ZTimestampTests,
	#superclass : #TestCase,
	#category : #'ZTimestamp-Tests'
}

{ #category : #asserting }
ZTimestampTests >> assertInvariants: timestamp [
	self assert: (timestamp isKindOf: ZTimestamp).
	self assert: timestamp julianDayNumber isInteger.
	self assert: (timestamp secondsSinceMidnight between: 0 and: (24 * 60 * 60) - 1).
	self assert: timestamp offset = Duration zero
]

{ #category : #asserting }
ZTimestampTests >> assertTimestamp: timestamp equalsTimestamp: reference [ 
	self assert: reference julianDayNumber = timestamp julianDayNumber.
	"Let's try to stay compatible between different Pharo versions, it is just for testing anyway"
	[ self assert: reference secondsSinceMidnight = timestamp secondsSinceMidnight ]
		on: Deprecation, MessageNotUnderstood  
		do: [ :exception |
			"Use the new selector in Pharo 3.0 and above"
			self assert: reference secondsSinceMidnightUTC = timestamp secondsSinceMidnightUTC.  
			exception return ].
	self assert: reference year = timestamp year.
	self assert: reference month = timestamp month.
	self assert: reference dayOfMonth = timestamp dayOfMonth.
	self assert: reference hour = timestamp hour.
	self assert: reference minute = timestamp minute.
	self assert: reference second = timestamp second
]

{ #category : #accessing }
ZTimestampTests >> lunarLanding [
	"First lunar landing, Apollo 11, Mare Tranquillitatis"
	
	^ ZTimestamp fromString: '1969-07-20T20:17:40Z'
]

{ #category : #accessing }
ZTimestampTests >> marsLanding [
	"First soft Mars landing, Viking 1, Chryse Planitia"
	
	^ ZTimestamp fromString: '1979-07-20T11:53:06Z'
]

{ #category : #testing }
ZTimestampTests >> testAddingOneDay [
	| t1 t2 |
	t1 := ZTimestamp year: 2012 month: 8 day: 7 hour: 14 minute: 20 second: 11.
	t2 := ZTimestamp year: 2012 month: 8 day: 8 hour: 14 minute: 20 second: 11.
	self assert: t1 < t2.
	self assert: (t1 + 1 day) equals: t2.
]

{ #category : #testing }
ZTimestampTests >> testAddingOneHour [
	| t1 t2 |
	t1 := ZTimestamp year: 2012 month: 8 day: 7 hour: 14 minute: 20 second: 11.
	t2 := ZTimestamp year: 2012 month: 8 day: 7 hour: 15 minute: 20 second: 11.
	self assert: t1 < t2.
	self assert: (t1 + 1 hour) equals: t2.
]

{ #category : #testing }
ZTimestampTests >> testAt [
	self assert: ZTimestamp @ '1969-07-20T20:17:40Z' equals: self lunarLanding.
	self assert: ZTimestamp @ '19690720T201740' equals: self lunarLanding.
	self assert: ZTimestamp @ '19690720' equals: self lunarLanding asBeginOfDay
]

{ #category : #testing }
ZTimestampTests >> testBasicFieldAccessors [
	| timestamp |
	timestamp := ZTimestamp year: 2012 month: 4 day: 20 hour: 15 minute: 50 second: 10.
	self assert: timestamp year equals: 2012.
	self assert: timestamp month equals: 4.
	self assert: timestamp dayOfMonth equals: 20.
	self assert: timestamp hour equals: 15.
	self assert: timestamp minute equals: 50.
	self assert: timestamp seconds equals: 10	
]

{ #category : #testing }
ZTimestampTests >> testBeginOfDay [
	| timestamp |
	timestamp := ZTimestamp year: 2012 month: 4 day: 20 hour: 15 minute: 50 second: 10.
	self assert: timestamp asBeginOfDay equals: (ZTimestamp year: 2012 month: 4 day: 20)
]

{ #category : #testing }
ZTimestampTests >> testCalculations [
	| delta |
	delta := self marsLanding - self lunarLanding.
	self assert: delta > Duration zero.
	self assert: self lunarLanding + delta equals: self marsLanding.
	self assert: self marsLanding - delta equals: self lunarLanding
]

{ #category : #testing }
ZTimestampTests >> testComparing [
	self assertInvariants: self marsLanding.
	self deny: self lunarLanding = self marsLanding.
	self assert: self lunarLanding < self marsLanding.
]

{ #category : #testing }
ZTimestampTests >> testConversions [
	| timestamp |
	timestamp := ZTimestamp year: 2012 month: 4 day: 20 hour: 15 minute: 50 second: 10.
	self assert: timestamp asDate year equals: 2012.
	self assert: timestamp asDate monthIndex equals: 4.
	self assert: timestamp asDate dayOfMonth equals: 20.
	self 
		assert: timestamp asTime
		equals: (Time hour: 15 minute: 50 second: 10).
	self 
		assert: timestamp asDateAndTime
		equals: (DateAndTime year: 2012 month: 4 day: 20 hour: 15 minute: 50 second: 10 offset: Duration zero).
	self assert: timestamp asZTimestamp = timestamp.
	self 
		assert: (DateAndTime year: 2012 month: 4 day: 20 hour: 15 minute: 50 second: 10 offset: Duration zero) asZTimestamp
		equals: timestamp.
	self 
		assert: (DateAndTime year: 2012 month: 4 day: 20 hour: 19 minute: 50 second: 10 offset: 4 hours) asZTimestamp
		equals: timestamp.

]

{ #category : #testing }
ZTimestampTests >> testCreationWithAllFields [
	| reference timestamp |
	reference := DateAndTime 
		year: 2012 
		month: 4 
		day: 20 
		hour: 15 
		minute: 50 
		second: 10 
		nanoSecond: 0 
		offset: Duration zero.
	timestamp := ZTimestamp 
		year: reference year 
		month: reference month 
		day: reference dayOfMonth 
		hour: reference hour 
		minute: reference minute 
		second: reference second.
	self assertTimestamp: reference equalsTimestamp: timestamp
]

{ #category : #testing }
ZTimestampTests >> testCreationWithDateFields [
	| reference timestamp |
	reference := DateAndTime 
		year: 2012 
		month: 4 
		day: 20 
		hour: 0 
		minute: 0 
		second: 0 
		nanoSecond: 0 
		offset: Duration zero.
	timestamp := ZTimestamp 
		year: reference year 
		month: reference month 
		day: reference dayOfMonth.
	self assertTimestamp: reference equalsTimestamp: timestamp
]

{ #category : #testing }
ZTimestampTests >> testDateError [
	| exceptionClass |
	exceptionClass := Smalltalk at: #DateError ifAbsent: [ Error ].
	self should: [ ZTimestamp year: 2018 month: 2 day: 31 ] raise: exceptionClass.
	self should: [ ZTimestamp year: 2018 month: 4 day: 31 ] raise: exceptionClass.
]

{ #category : #testing }
ZTimestampTests >> testEndOfDay [
	| timestamp |
	timestamp := ZTimestamp year: 2012 month: 4 day: 20 hour: 15 minute: 50 second: 10.
	self assert: timestamp asEndOfDay equals: (ZTimestamp year: 2012 month: 4 day: 20 hour: 23 minute: 59 second: 59 nanoSecond: 1e9 - 1)
]

{ #category : #testing }
ZTimestampTests >> testEpoch [
	| epoch |
	epoch := ZTimestamp epoch.
	self assert: epoch equals: ZTimestamp zero.
	self assert: epoch julianDayNumber equals: 0.
	self assert: epoch secondsSinceMidnight equals: 0.
	"astronomical year to proleptic Gregorian year"
	self assert: epoch year equals: -4713.
	self assert: epoch month equals: 11.
	self assert: epoch dayOfMonth equals: 24.
	
]

{ #category : #testing }
ZTimestampTests >> testEquality [
	| t1 t2 now |
	t1 := ZTimestamp year: 2012 month: 8 day: 7 hour: 14 minute: 20 second: 11.
	t2 := ZTimestamp year: 2012 month: 8 day: 7 hour: 14 minute: 20 second: 11.
	self assert: t1 equals: t2.
	now := ZTimestamp now.
	self assert: now equals: now.
	self assert: ZTimestamp unixEpoch equals: ZTimestamp unixEpoch.
]

{ #category : #testing }
ZTimestampTests >> testFormatting [
	| timestamp formatter |
	timestamp := ZTimestamp year: 2012 month: 4 day: 20 hour: 15 minute: 50 second: 10.
	formatter := [ :format | 
		String streamContents: [ :stream | 
			timestamp printOn: stream format: format ] ].
	self assert: (formatter value: #($- $T $: $Z)) equals: '2012-04-20T15:50:10Z'.
	self assert: (formatter value: #(nil $T nil nil)) equals: '20120420T155010'.
	self assert: (formatter value: #($/ $| $: $Z)) equals: '2012/04/20|15:50:10Z'.
	self assert: (formatter value: #($- $T $: nil)) equals: '2012-04-20T15:50:10'.
]

{ #category : #testing }
ZTimestampTests >> testHashing [
	| array set now |
	now := ZTimestamp now.
	array := { now. self lunarLanding. self marsLanding. self unixTimeBillenium }.
	set := array asSet.
	self assert: array size equals: set size.
	array do: [ :each |
		self assert: (set includes: each) ].
	set addAll: array.
	self assert: array size equals: set size.
	array do: [ :each |
		self assert: (set includes: each) ].
]

{ #category : #testing }
ZTimestampTests >> testJulianDate [
	| now julianDate |
	now := ZTimestamp now.
	julianDate := now julianDate.
	self assert: (ZTimestamp fromJulianDate: julianDate) - now < 1 second
]

{ #category : #testing }
ZTimestampTests >> testLunarLanding [
	| timestamp |
	timestamp := self lunarLanding.
	self assertInvariants: timestamp.
	self assert: timestamp monthName equals: #July.
	self assert: timestamp dayOfWeekName equals: #Sunday.
	self assert: timestamp dayOfYear equals: 201.
]

{ #category : #testing }
ZTimestampTests >> testMixedCalculations [
	| now delta |
	now := DateAndTime now truncated asUTC.
	delta := now - self lunarLanding.
	self assert: delta > Duration zero.
	self assert: self lunarLanding + delta equals: now asZTimestamp.
	self assert: (self lunarLanding + delta) asDateAndTime equals: now.
	self assert: (now - delta) asZTimestamp equals: self lunarLanding.
	self assert: (now - delta) equals: self lunarLanding asDateAndTime
]

{ #category : #testing }
ZTimestampTests >> testNow [
	self assertInvariants: ZTimestamp now
]

{ #category : #testing }
ZTimestampTests >> testOneDayDifference [
	| t1 t2 |
	t1 := ZTimestamp year: 2012 month: 8 day: 7 hour: 14 minute: 20 second: 11.
	t2 := ZTimestamp year: 2012 month: 8 day: 8 hour: 14 minute: 20 second: 11.
	self assert: t1 < t2.
	self assert: (t2 - t1) equals: 1 day
]

{ #category : #testing }
ZTimestampTests >> testOneHourDifference [
	| t1 t2 |
	t1 := ZTimestamp year: 2012 month: 8 day: 7 hour: 14 minute: 20 second: 11.
	t2 := ZTimestamp year: 2012 month: 8 day: 7 hour: 15 minute: 20 second: 11.
	self assert: t1 < t2.
	self assert: (t2 - t1) equals: 1 hour.
]

{ #category : #testing }
ZTimestampTests >> testOptionalTimezoneParsing [
	#( 
		'1969-07-20T20:17:40Z'
		'1969-07-20T20:17:40'
		'1969-07-20T20:17:40+00:00'
		'1969-07-20T20:17:40+00'
		'1969-07-20T20:17:40+0000'
		'1969-07-20T21:17:40+01:00'
		'1969-07-20T21:17:40+01'
		'1969-07-20T21:17:40+0100'
		'1969-07-20T19:17:40-01:00'
		'1969-07-20T19:17:40-01'
		'1969-07-20T19:17:40-0100'
		'1969-07-20T21:47:40+01:30'
		'1969-07-20T21:47:40+0130'
		'1969-07-20T18:47:40-01:30'
		'1969-07-20T18:47:40-0130' ) do: [ :each |
		self assert: (ZTimestamp fromString: each) equals: self lunarLanding ]
]

{ #category : #testing }
ZTimestampTests >> testParseEpoch [
	| epoch |
	epoch := ZTimestamp epoch.
	self assert: (ZTimestamp fromString: epoch asString) equals: epoch
]

{ #category : #testing }
ZTimestampTests >> testParsing [
	| timestamp |
	timestamp := ZTimestamp year: 2012 month: 8 day: 7 hour: 14 minute: 20 second: 11.
	self assert: (ZTimestamp readFrom: '2012-08-07T14:20:11Z' readStream) equals: timestamp.
	self assert: (ZTimestamp readFrom: '20120807T142011' readStream) equals: timestamp.
	self assert: (ZTimestamp readFrom: '20120807142011' readStream) equals: timestamp.
	self assert: (ZTimestamp readFrom: '2012-08-07T14:20:11' readStream) equals: timestamp.
	self assert: (ZTimestamp readFrom: '2012-08-07T14:20:11+00:00' readStream) equals: timestamp.
	self assert: (ZTimestamp readFrom: '2012-08-07T16:20:11+02:00' readStream) equals: timestamp.
	self assert: (ZTimestamp readFrom: '2012-08-07T12:20:11-02:00' readStream) equals: timestamp.
]

{ #category : #testing }
ZTimestampTests >> testParsingDates [
	| timestamp |
	timestamp := ZTimestamp year: 2012 month: 8 day: 7.
	self assert: (ZTimestamp readFrom: '2012-08-07' readStream) equals: timestamp.
	self assert: (ZTimestamp readFrom: '20120807' readStream) equals: timestamp.
]

{ #category : #testing }
ZTimestampTests >> testParsingError [
	self should: [ ZTimestamp fromString: '45451-09-06T11:01:07Z' ] raise: Error
]

{ #category : #testing }
ZTimestampTests >> testParsingReducedAccuracy [
	| timestamp |
	timestamp := ZTimestamp year: 2012 month: 8 day: 7.
	self assert: (ZTimestamp readFrom: '2012-08-07T00:00:00Z' readStream) equals: timestamp.
	self assert: (ZTimestamp readFrom: '2012-08-07T00:00:00' readStream) equals: timestamp.
	self assert: (ZTimestamp readFrom: '2012-08-07T00:00' readStream) equals: timestamp.
	self assert: (ZTimestamp readFrom: '2012-08-07T00' readStream) equals: timestamp.
	self assert: (ZTimestamp readFrom: '2012-08-07T' readStream) equals: timestamp.
	self assert: (ZTimestamp readFrom: '2012-08-07' readStream) equals: timestamp.
	self assert: (ZTimestamp readFrom: '20120807T000000Z' readStream) equals: timestamp.
	self assert: (ZTimestamp readFrom: '20120807T000000' readStream) equals: timestamp.
	self assert: (ZTimestamp readFrom: '20120807T0000' readStream) equals: timestamp.
	self assert: (ZTimestamp readFrom: '20120807T00' readStream) equals: timestamp.
	self assert: (ZTimestamp readFrom: '20120807T' readStream) equals: timestamp.
	self assert: (ZTimestamp readFrom: '20120807' readStream) equals: timestamp.

]

{ #category : #testing }
ZTimestampTests >> testPrintString [
	| timestamp |
	timestamp := ZTimestamp year: 2012 month: 4 day: 20 hour: 15 minute: 50 second: 10.
	self assert: timestamp printString equals: '2012-04-20T15:50:10Z'.
	timestamp := ZTimestamp year: -12 month: 4 day: 20 hour: 15 minute: 50 second: 10.
	self assert: timestamp printString equals: '-0012-04-20T15:50:10Z'
]

{ #category : #testing }
ZTimestampTests >> testSTON [
	Smalltalk at: #STON ifPresent: [ :ston | 
		| now |
		now := ZTimestamp now.
		self 
			assert: (ston fromString: (ston toString: now)) 
			equals: now ]
]

{ #category : #testing }
ZTimestampTests >> testSorting [
	| array sorted now |
	now := ZTimestamp now.
	array := { now. self lunarLanding. self marsLanding. self unixTimeBillenium }.
	sorted := array sorted.
	self assert: sorted first equals: self lunarLanding.
	self assert: sorted last equals: now
]

{ #category : #testing }
ZTimestampTests >> testStringAsZTimestamp [
	self assert: '1969-07-20T20:17:40Z' asZTimestamp equals: self lunarLanding. 
	self assert: '1969/07/20 20:17:40+00:00' asZTimestamp equals: self lunarLanding. 
	self assert: '19690720T201740Z' asZTimestamp equals: self lunarLanding. 
	self assert: '19690720' asZTimestamp equals: self lunarLanding asBeginOfDay 
]

{ #category : #testing }
ZTimestampTests >> testTimezoneFormatting [
	| timestamp formatter |
	timestamp := ZTimestamp year: 2012 month: 4 day: 20 hour: 15 minute: 50 second: 10.
	formatter := [ :format :timezone| 
		String streamContents: [ :stream | 
			timestamp printOn: stream format: format timezone: timezone] ].
	self assert: (formatter value: #($- $T $: nil) value: 2 hours) equals: '2012-04-20T17:50:10+02:00'.
	self assert: (formatter value: #($- $T $: nil) value: -2 hours) equals: '2012-04-20T13:50:10-02:00'.
	self assert: (formatter value: #(nil $T nil nil) value: 1 hours) equals: '20120420T165010+0100'.
	self assert: (formatter value: #(nil $T nil nil) value: -1 hours) equals: '20120420T145010-0100'.

]

{ #category : #testing }
ZTimestampTests >> testToday [
	self assert: ZTimestamp today secondsSinceMidnight isZero
]

{ #category : #testing }
ZTimestampTests >> testUnixTime [
	| timestamp billenium |
	timestamp := ZTimestamp fromUnixTime: 1000000000.
	billenium := self unixTimeBillenium.
	self assert: timestamp equals: billenium.
	self assert: billenium asUnixTime equals: 1000000000
]

{ #category : #testing }
ZTimestampTests >> testZTimestampFormatting [
	| timestamp |
	timestamp := self lunarLanding.
	self 
		assert: (timestamp format: '2001-02-03T16:05:06Z') 
		equals: '1969-07-20T20:17:40Z'.
	self 
		assert: (String streamContents: [ :out | timestamp format: '01/02/03 16:05:06' on: out ]) 
		equals: '69/07/20 20:17:40'.

]

{ #category : #accessing }
ZTimestampTests >> unixTimeBillenium [
	"1 billion seconds since the Unix Epoch"
	
	^ ZTimestamp fromString: '2001-09-09T01:46:40Z'.
]
