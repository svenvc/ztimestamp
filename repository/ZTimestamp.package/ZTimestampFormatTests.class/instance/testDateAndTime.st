testing
testDateAndTime
	| now format |
	now := DateAndTime now rounded.
	format := ZTimestampFormat fromString: '2001-02-03T16:05:06+00:00'.
	self 
		assert: (format format: now)
		equals: now printString.	
	format createDateAndTime.
	self
		assert: (format parse: now printString)
		equals: now.