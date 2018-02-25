testing
testParsing
	| timestamp |
	timestamp := ZTimestamp year: 2012 month: 8 day: 7 hour: 14 minute: 20 second: 11.
	self assert: (ZTimestamp readFrom: '2012-08-07T14:20:11Z' readStream) equals: timestamp.
	self assert: (ZTimestamp readFrom: '20120807T142011' readStream) equals: timestamp.
	self assert: (ZTimestamp readFrom: '20120807142011' readStream) equals: timestamp.
	self assert: (ZTimestamp readFrom: '2012-08-07T14:20:11' readStream) equals: timestamp.
	self assert: (ZTimestamp readFrom: '2012-08-07T14:20:11+00:00' readStream) equals: timestamp.
	self assert: (ZTimestamp readFrom: '2012-08-07T16:20:11+02:00' readStream) equals: timestamp.
	self assert: (ZTimestamp readFrom: '2012-08-07T12:20:11-02:00' readStream) equals: timestamp.