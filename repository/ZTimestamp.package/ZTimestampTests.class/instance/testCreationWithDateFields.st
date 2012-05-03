testing
testCreationWithDateFields
	| reference timestamp |
	reference := DateAndTime 
		year: 2012 
		month: 4 
		day: 20 
		hour: 0 
		minute: 0 
		second: 0 
		nanoSecond: 0 
		offset: Duration zero.
	timestamp := ZTimestamp 
		year: reference year 
		month: reference month 
		day: reference dayOfMonth.
	self assertTimestamp: reference equalsTimestamp: timestamp