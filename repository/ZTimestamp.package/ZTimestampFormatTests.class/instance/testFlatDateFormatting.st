testing
testFlatDateFormatting
	self
		assert: ((ZTimestampFormat fromString: '20010203') format: (Date year: 1967 month: 8 day: 7))
		equals: '19670807'.
	self
		assert: ((ZTimestampFormat fromString: '02032001') format: (Date year: 1967 month: 8 day: 7))
		equals: '08071967'.
	self
		assert: ((ZTimestampFormat fromString: '03022001') format: (Date year: 1967 month: 8 day: 7))
		equals: '07081967'.