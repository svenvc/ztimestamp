testing
testDateCreation
	self 
		assert: ((ZTimestampFormat fromString: '03/02/2001') createDate; parse: '07/08/1967')
		equals: (Date year: 1967 month: 8 day: 7).	