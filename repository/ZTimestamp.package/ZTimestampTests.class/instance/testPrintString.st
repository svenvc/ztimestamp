testing
testPrintString
	| timestamp |
	timestamp := ZTimestamp year: 2012 month: 4 day: 20 hour: 15 minute: 50 second: 10.
	self assert: timestamp printString = '2012-04-20T15:50:10Z'