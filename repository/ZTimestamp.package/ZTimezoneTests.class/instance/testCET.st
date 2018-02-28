testing
testCET
	
	| timestamp timeA timeB |
	 
	timestamp := ZTimestamp now.
	timeA := (ZTimezone id: 'CET') localToGmt: timestamp.
	timeB := (ZTimezone id: 'Europe/Paris') localToGmt: timestamp.
	
	self assert: timeA equals: timeB