testing
testParsingReducedAccuracy
	| timestamp |
	timestamp := ZTimestamp year: 2012 month: 8 day: 7.
	self assert: (ZTimestamp readFrom: '2012-08-07T00:00:00Z' readStream) equals: timestamp.
	self assert: (ZTimestamp readFrom: '2012-08-07T00:00:00' readStream) equals: timestamp.
	self assert: (ZTimestamp readFrom: '2012-08-07T00:00' readStream) equals: timestamp.
	self assert: (ZTimestamp readFrom: '2012-08-07T00' readStream) equals: timestamp.
	self assert: (ZTimestamp readFrom: '2012-08-07T' readStream) equals: timestamp.
	self assert: (ZTimestamp readFrom: '2012-08-07' readStream) equals: timestamp.
	self assert: (ZTimestamp readFrom: '20120807T000000Z' readStream) equals: timestamp.
	self assert: (ZTimestamp readFrom: '20120807T000000' readStream) equals: timestamp.
	self assert: (ZTimestamp readFrom: '20120807T0000' readStream) equals: timestamp.
	self assert: (ZTimestamp readFrom: '20120807T00' readStream) equals: timestamp.
	self assert: (ZTimestamp readFrom: '20120807T' readStream) equals: timestamp.
	self assert: (ZTimestamp readFrom: '20120807' readStream) equals: timestamp.
