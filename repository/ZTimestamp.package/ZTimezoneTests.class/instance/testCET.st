testing
testCET
	
	| timestamp timeA timeB |
	 
	timestamp := ZTimestamp now.
	timeA := (ZTimezone id: 'CET') localToGmt: timestamp.
	timeB := (ZTimezone id: 'Europe/Brussels') localToGmt: timestamp.
	
	self assert: timeA equals: timeB