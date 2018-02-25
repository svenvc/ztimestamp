testing
testDateError
	self should: [ ZTimestamp year: 2018 month: 2 day: 31 ] raise: DateError.
	self should: [ ZTimestamp year: 2018 month: 4 day: 31 ] raise: DateError.