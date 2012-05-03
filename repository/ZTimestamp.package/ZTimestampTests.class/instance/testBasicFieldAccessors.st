testing
testBasicFieldAccessors
	| timestamp |
	timestamp := ZTimestamp year: 2012 month: 4 day: 20 hour: 15 minute: 50 second: 10.
	self assert: timestamp year = 2012.
	self assert: timestamp month = 4.
	self assert: timestamp dayOfMonth = 20.
	self assert: timestamp hour = 15.
	self assert: timestamp minute = 50.
	self assert: timestamp seconds = 10	