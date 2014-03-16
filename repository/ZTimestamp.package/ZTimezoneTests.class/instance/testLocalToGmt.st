testing
testLocalToGmt
	| timezone |
	timezone := ZTimezone id: 'Europe/Brussels'.
	self 
		assert: (timezone localToGmt: (ZTimestamp fromString: '2014-01-15T12:00:00Z'))
		equals: (ZTimestamp fromString: '2014-01-15T11:00:00Z').
	self 
		assert: (timezone localToGmt: (ZTimestamp fromString: '2014-08-15T12:00:00Z'))
		equals: (ZTimestamp fromString: '2014-08-15T10:00:00Z').