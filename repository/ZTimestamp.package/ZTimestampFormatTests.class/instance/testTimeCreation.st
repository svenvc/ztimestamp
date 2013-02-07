testing
testTimeCreation
	self 
		assert: ((ZTimestampFormat fromString: '4:05:06PM') createTime; parse: '8:11:12PM')
		equals: (Time hour: 20 minute: 11 second: 12).	