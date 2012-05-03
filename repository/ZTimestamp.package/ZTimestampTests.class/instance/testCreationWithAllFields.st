testing
testCreationWithAllFields
	| reference timestamp |
	reference := DateAndTime 
		year: 2012 
		month: 4 
		day: 20 
		hour: 15 
		minute: 50 
		second: 10 
		nanoSecond: 0 
		offset: Duration zero.
	timestamp := ZTimestamp 
		year: reference year 
		month: reference month 
		day: reference dayOfMonth 
		hour: reference hour 
		minute: reference minute 
		second: reference second.
	self assertTimestamp: reference equalsTimestamp: timestamp