testing
testEndOfDay
	| timestamp |
	timestamp := ZTimestamp year: 2012 month: 4 day: 20 hour: 15 minute: 50 second: 10.
	self assert: timestamp asEndOfDay equals: (ZTimestamp year: 2012 month: 4 day: 20 hour: 23 minute: 59 second: 59)