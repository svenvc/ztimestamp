testing
testDateParsing
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