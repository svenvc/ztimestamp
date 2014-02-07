testing
testDateFormatting
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