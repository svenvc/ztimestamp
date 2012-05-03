testing
testConversions
	| timestamp |
	timestamp := ZTimestamp year: 2012 month: 4 day: 20 hour: 15 minute: 50 second: 10.
	self assert: timestamp asDate = (Date year: 2012 month: 4 day: 20).
	self assert: timestamp asTime = (Time hour: 15 minute: 50 second: 10).
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
