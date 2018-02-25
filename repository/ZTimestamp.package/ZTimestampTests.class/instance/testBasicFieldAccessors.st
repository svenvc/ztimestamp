testing
testBasicFieldAccessors
	| timestamp |
	timestamp := ZTimestamp year: 2012 month: 4 day: 20 hour: 15 minute: 50 second: 10.
	self assert: timestamp year equals: 2012.
	self assert: timestamp month equals: 4.
	self assert: timestamp dayOfMonth equals: 20.
	self assert: timestamp hour equals: 15.
	self assert: timestamp minute equals: 50.
	self assert: timestamp seconds equals: 10	