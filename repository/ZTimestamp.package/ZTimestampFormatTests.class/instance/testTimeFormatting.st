testing
testTimeFormatting
	self
		assert: ((ZTimestampFormat fromString: '04:05:06') 
						format: (ZTimestamp year: 0 month: 0 day: 0 hour: 11 minute: 30 second: 19))
		equals: '11:30:19'.