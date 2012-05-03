testing
testParsingDates
	| timestamp |
	timestamp := ZTimestamp year: 2012 month: 8 day: 7.
	self assert: (ZTimestamp readFrom: '2012-08-07' readStream) = timestamp.
	self assert: (ZTimestamp readFrom: '20120807' readStream) = timestamp.