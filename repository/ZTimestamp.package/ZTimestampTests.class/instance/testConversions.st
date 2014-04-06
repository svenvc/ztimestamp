testing
testConversions
	| timestamp |
	timestamp := ZTimestamp year: 2012 month: 4 day: 20 hour: 15 minute: 50 second: 10.
	self assert: timestamp asDate year equals: 2012.
	self assert: timestamp asDate monthIndex equals: 4.
	self assert: timestamp asDate dayOfMonth equals: 20.
	self 
		assert: timestamp asTime
		equals: (Time hour: 15 minute: 50 second: 10).
	self 
		assert: timestamp asTimeStamp 
		equals: (TimeStamp year: 2012 month: 4 day: 20 hour: 15 minute: 50 second: 10 offset: Duration zero).
	self 
		assert: timestamp asDateAndTime
		equals: (DateAndTime year: 2012 month: 4 day: 20 hour: 15 minute: 50 second: 10 offset: Duration zero).
	self assert: timestamp asZTimestamp = timestamp.
	self 
		assert: (TimeStamp year: 2012 month: 4 day: 20 hour: 15 minute: 50 second: 10 offset: Duration zero) asZTimestamp
		equals: timestamp.
	self 
		assert: (DateAndTime year: 2012 month: 4 day: 20 hour: 15 minute: 50 second: 10 offset: Duration zero) asZTimestamp
		equals: timestamp.
	self 
		assert: (DateAndTime year: 2012 month: 4 day: 20 hour: 19 minute: 50 second: 10 offset: 4 hours) asZTimestamp
		equals: timestamp.
