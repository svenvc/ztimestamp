testing
testGmtToLocal
	| timezone |
	timezone := ZTimezone id: 'Europe/Brussels'.
	self 
		assert: (timezone gmtToLocal: (ZTimestamp fromString: '2014-01-15T12:00:00Z'))
		equals: (ZTimestamp fromString: '2014-01-15T13:00:00Z').
	self 
		assert: (timezone gmtToLocal: (ZTimestamp fromString: '2014-08-15T12:00:00Z'))
		equals: (ZTimestamp fromString: '2014-08-15T14:00:00Z').