testing
testTimeParsing
	self
		assert: ((ZTimestampFormat fromString: '04:05:06') parse: '11:30:19')
		equals: (ZTimestamp year: 0 month: 0 day: 0 hour: 11 minute: 30 second: 19).
	self
		assert: ((ZTimestampFormat fromString: '16:05:06') parse: '22:30:19')
		equals: (ZTimestamp year: 0 month: 0 day: 0 hour: 22 minute: 30 second: 19).
	self
		assert: ((ZTimestampFormat fromString: '04:05:06 PM') parse: '11:30:19 AM')
		equals: (ZTimestamp year: 0 month: 0 day: 0 hour: 11 minute: 30 second: 19).
	self
		assert: ((ZTimestampFormat fromString: '04:05:06 PM') parse: '11:30:19 PM')
		equals: (ZTimestamp year: 0 month: 0 day: 0 hour: 23 minute: 30 second: 19).