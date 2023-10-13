"
I am ZTimestampFormatTests, a suite of unit tests for ZTimestampFormat.
"
Class {
	#name : #ZTimestampFormatTests,
	#superclass : #TestCase,
	#category : #'ZTimestamp-Tests'
}

{ #category : #testing }
ZTimestampFormatTests >> testAMPM [
	| times format12 format24 |
	times := #( 
		('12:00AM' '00:00') ('12:01AM' '00:01') ('12:59AM' '00:59') ('01:00AM' '01:00') ('11:00AM' '11:00') ('11:59AM' '11:59')
		('12:00PM' '12:00') ('12:01PM' '12:01') ('12:59PM' '12:59')('01:00PM' '13:00') ('11:00PM' '23:00') ('11:59PM' '23:59') ).
	format12 := (ZTimestampFormat fromString: '04:05PM') createZTimestampDefaultDate111; yourself.
	format24 := (ZTimestampFormat fromString: '16:05') createZTimestampDefaultDate111; yourself.
	times do: [ :each |
		self assert: (format12 parse: each first) equals: (format24 parse: each second).
		self assert: (format12 format: (format12 parse: each first)) equals: each first.
		self assert: (format24 format: (format24 parse: each second)) equals: each second ]
]

{ #category : #testing }
ZTimestampFormatTests >> testCurrentTimezoneFormatting [
	| format winter summer |
	winter := ZTimestamp year: 2014 month: 1 day: 1 hour: 11 minute: 0 second: 0.
	summer := ZTimestamp year: 2014 month: 8 day: 1 hour: 11 minute: 0 second: 0.
	ZCurrentTimezone 
		value: (ZTimezone id: #'Europe/Brussels')
		during: [ 
			format := ZTimestampFormat iso.
			format useCurrentTimezone.
			self 
				assert: (format format: winter)
				equals: '2014-01-01T12:00:00+01:00'.
			self 
				assert: (format format: summer)
				equals: '2014-08-01T13:00:00+02:00'.
			format specification: '20010203T1605'.
			self 
				assert: (format format: winter)
				equals: '20140101T1200'.
			self 
				assert: (format format: summer)
				equals: '20140801T1300' ]
]

{ #category : #testing }
ZTimestampFormatTests >> testCurrentTimezoneParsing [
	| format winter summer |
	winter := ZTimestamp year: 2014 month: 1 day: 1 hour: 11 minute: 0 second: 0.
	summer := ZTimestamp year: 2014 month: 8 day: 1 hour: 11 minute: 0 second: 0.
	ZCurrentTimezone 
		value: (ZTimezone id: #'Europe/Brussels')
		during: [ 
			format := ZTimestampFormat fromString: '2001-02-03T16:05'.
			format useCurrentTimezone.
			self 
				assert: (format parse: '2014-01-01T12:00')
				equals: winter.
			self 
				assert: (format parse: '2014-08-01T13:00')
				equals: summer.
			format specification: '2001-02-03T16:05+00:00'.
			self 
				assert: (format parse: '2014-01-01T16:00+05:00')
				equals: winter.
			self 
				assert: (format parse: '2014-08-01T15:00+04:00')
				equals: summer ]
]

{ #category : #testing }
ZTimestampFormatTests >> testDateAndTime [
	| now format |
	now := DateAndTime now rounded.
	format := ZTimestampFormat fromString: '2001-02-03T16:05:06+00:00'.
	self 
		assert: (format format: now)
		equals: now printString.	
	format createDateAndTime.
	self
		assert: (format parse: now printString)
		equals: now.
]

{ #category : #testing }
ZTimestampFormatTests >> testDateAndTimeWithNanoseconds [
	| now format |
	now := DateAndTime now.
	format := ZTimestampFormat fromString: '2001-02-03T16:05:06.7+00:00'.
	self 
		assert: (format format: now)
		equals: now printString.	
	format createDateAndTime.
	self
		assert: (format parse: now printString)
		equals: now.
]

{ #category : #testing }
ZTimestampFormatTests >> testDateCreation [
	self 
		assert: ((ZTimestampFormat fromString: '03/02/2001') createDate; parse: '07/08/1967')
		equals: (Date year: 1967 month: 8 day: 7).	
]

{ #category : #testing }
ZTimestampFormatTests >> testDateFormatting [
	self
		assert: ((ZTimestampFormat fromString: '2001/02/03') format: (ZTimestamp year: 2012 month: 10 day: 20))
		equals: '2012/10/20'.
	self
		assert: ((ZTimestampFormat fromString: '3 February 2001') format: (ZTimestamp year: 2012 month: 10 day: 20))
		equals: '20 October 2012'.
	self
		assert: ((ZTimestampFormat fromString: '_3 February 2001') 
						french;
						format: (ZTimestamp year: 1967 month: 8 day: 7))
		equals: ' 7 Août 1967'.
	self
		assert: ((ZTimestampFormat fromString: '3 FEB ''01') format: (ZTimestamp year: 2012 month: 10 day: 20))
		equals: '20 OCT ''12'.
]

{ #category : #testing }
ZTimestampFormatTests >> testDateParsing [
	self
		assert: ((ZTimestampFormat fromString: '2001/02/03') parse: '2012/10/20') 
		equals: (ZTimestamp year: 2012 month: 10 day: 20).
	self
		assert: ((ZTimestampFormat fromString: '3 FEB ''01') parse: '20 OCT ''12') 
		equals: (ZTimestamp year: 2012 month: 10 day: 20).
	self
		assert: ((ZTimestampFormat fromString: '3 February 2001') parse: '20 October 2012') 
		equals: (ZTimestamp year: 2012 month: 10 day: 20).
	self
		assert: ((ZTimestampFormat fromString: '_3 February 2001') 
						french;
						parse: ' 7 Août 1967') 
		equals: (ZTimestamp year: 1967 month: 8 day: 7).
]

{ #category : #testing }
ZTimestampFormatTests >> testExplicitTimezoneFormatting [
	| format winter summer |
	winter := ZTimestamp year: 2014 month: 1 day: 1 hour: 11 minute: 0 second: 0.
	summer := ZTimestamp year: 2014 month: 8 day: 1 hour: 11 minute: 0 second: 0.
	format := ZTimestampFormat iso.
	format timezone: (ZTimezone id: #'Europe/Brussels').
	self 
		assert: (format format: winter)
		equals: '2014-01-01T12:00:00+01:00'.
	self 
		assert: (format format: summer)
		equals: '2014-08-01T13:00:00+02:00'.
	format specification: '20010203T1605'.
	self 
		assert: (format format: winter)
		equals: '20140101T1200'.
	self 
		assert: (format format: summer)
		equals: '20140801T1300'.
	
]

{ #category : #testing }
ZTimestampFormatTests >> testFlatDateFormatting [
	self
		assert: ((ZTimestampFormat fromString: '20010203') format: (Date year: 1967 month: 8 day: 7))
		equals: '19670807'.
	self
		assert: ((ZTimestampFormat fromString: '02032001') format: (Date year: 1967 month: 8 day: 7))
		equals: '08071967'.
	self
		assert: ((ZTimestampFormat fromString: '03022001') format: (Date year: 1967 month: 8 day: 7))
		equals: '07081967'.
]

{ #category : #testing }
ZTimestampFormatTests >> testMonthNames [
	#(english french german dutch) do: [ :language | | format |
		format := ZTimestampFormat fromString: '03-February-2001'.
		format perform: language.
		1 to: 12 do: [ :month | | timestamp |
			timestamp := ZTimestamp year: 2012 month: month day: 10. 
			self 
				assert: (format parse: (format format: timestamp))
				equals: timestamp ] ]
]

{ #category : #testing }
ZTimestampFormatTests >> testPredefinedFormats [
	| reference now |
	reference := ZTimestampFormat reference24.
	now := DateAndTime now truncated.
	#(ansiC verbose kitchen clock rfc3339 rfc822 rfc850 unixDate euDate usDate isoDate) 
		do: [ :each | | format target |
			format := ZTimestampFormat perform: each.
			target := format specification copy replaceAll: $_ with: $ . 
			self assert: (format format: reference) equals: target ].
	#(verbose rfc3339 iso isoTZ) 
		do: [ :each | | format |
			(format := ZTimestampFormat perform: each)
				createDateAndTime.
			self assert: (format parse: (format format: now)) equals: now ].
	now := ZTimestamp now rounded.
	#(isoCompact) 
		do: [ :each | | format|
			format := ZTimestampFormat perform: each.
			self assert: (format parse: (format format: now)) equals: now ].
	
]

{ #category : #testing }
ZTimestampFormatTests >> testReferenceDateAndTime [
	| reference format now |
	reference := ZTimestampFormat reference12 asDateAndTime.
	(format := ZTimestampFormat fromString: reference printString)
		createDateAndTime.
	self assert: (format format: reference) equals: reference printString.
	self assert: (format parse: reference printString) equals: reference.
	reference := ZTimestampFormat reference24 asDateAndTime.
	(format := ZTimestampFormat fromString: reference printString)
		createDateAndTime.
	self assert: (format format: reference) equals: reference printString.
	self assert: (format parse: reference printString) equals: reference.
	now := DateAndTime now truncated.
	self assert: (format format: now) equals: now printString.
	self assert: (format parse: now printString) equals: now.
	
]

{ #category : #testing }
ZTimestampFormatTests >> testRfc3339 [
	| now |
	now := ZTimestamp now rounded.
	self 
		assert: (ZTimestampFormat rfc3339 format: now)
		equals: now printString.
	self
		assert: (ZTimestampFormat rfc3339 parse: now printString)
		equals: now.
	self 
		assert: (ZTimestampFormat rfc3339 format: ZTimestampFormat reference12)
		equals: ZTimestampFormat reference12 printString.
	self
		assert: (ZTimestampFormat rfc3339 parse: ZTimestampFormat reference12 printString)
		equals: ZTimestampFormat reference12.
	self 
		assert: (ZTimestampFormat rfc3339 format: ZTimestampFormat reference24)
		equals: ZTimestampFormat reference24 printString.
	self
		assert: (ZTimestampFormat rfc3339 parse: ZTimestampFormat reference24 printString)
		equals: ZTimestampFormat reference24.
]

{ #category : #testing }
ZTimestampFormatTests >> testTimeCreation [
	self 
		assert: ((ZTimestampFormat fromString: '4:05:06PM') createTime; parse: '8:11:12PM')
		equals: (Time hour: 20 minute: 11 second: 12).	
]

{ #category : #testing }
ZTimestampFormatTests >> testTimeFormatting [
	self
		assert: ((ZTimestampFormat fromString: '04:05:06') 
						format: (ZTimestamp year: 1 month: 1 day: 1 hour: 11 minute: 30 second: 19))
		equals: '11:30:19'.
]

{ #category : #testing }
ZTimestampFormatTests >> testTimeParsing [
	self
		assert: ((ZTimestampFormat fromString: '04:05:06') createZTimestampDefaultDate111; parse: '11:30:19')
		equals: (ZTimestamp year: 1 month: 1 day: 1 hour: 11 minute: 30 second: 19).
	self
		assert: ((ZTimestampFormat fromString: '16:05:06') createZTimestampDefaultDate111; parse: '22:30:19')
		equals: (ZTimestamp year: 1 month: 1 day: 1 hour: 22 minute: 30 second: 19).
	self
		assert: ((ZTimestampFormat fromString: '04:05:06 PM') createZTimestampDefaultDate111; parse: '11:30:19 AM')
		equals: (ZTimestamp year: 1 month: 1 day: 1 hour: 11 minute: 30 second: 19).
	self
		assert: ((ZTimestampFormat fromString: '04:05:06 PM') createZTimestampDefaultDate111; parse: '11:30:19 PM')
		equals: (ZTimestamp year: 1 month: 1 day: 1 hour: 23 minute: 30 second: 19).
]

{ #category : #accessing }
ZTimestampFormatTests >> testTransitionFormatting [
	| t1 t2 |
	t1 := ZTimestamp fromUnixTime: 1679792400. "winter->summer"
	t2 := ZTimestamp fromUnixTime: 1698541200. "summer->winter"
	ZCurrentTimezone
		value: ZTimezone europeBrussels
		during: [
			self
				assert: (ZTimestampFormat isoTZ useCurrentTimezone; format: t1)
				equals: '2023-03-26T03:00:00+02:00'.
			self
				assert: (ZTimestampFormat isoTZ useCurrentTimezone; format: t1 - 1 second)
				equals: '2023-03-26T01:59:59+01:00'.

			self
				assert: (ZTimestampFormat isoTZ useCurrentTimezone; format: t2)
				equals: '2023-10-29T02:00:00+01:00'.
			self
				assert: (ZTimestampFormat isoTZ useCurrentTimezone; format: t2 - 1 second)
				equals: '2023-10-29T02:59:59+02:00'.
 ]
]

{ #category : #testing }
ZTimestampFormatTests >> testWeekdayNames [
	| timestamp |
	timestamp := ZTimestamp year: 2012 month: 11 day: 3. 
	#(english french german dutch) do: [ :language | | format |
		format := ZTimestampFormat fromString: 'Saturday, 03-Feb-2001'.
		format perform: language.
		1 to: 7 do: [ :weekday |
			self 
				assert: (format parse: (format format: timestamp + weekday days))
				equals: (timestamp + weekday days) ] ]
]
