testing
testTimeParsing
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