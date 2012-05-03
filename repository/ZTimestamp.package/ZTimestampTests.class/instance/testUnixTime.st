testing
testUnixTime
	| timestamp billenium |
	timestamp := ZTimestamp fromUnixTime: 1000000000.
	billenium := self unixTimeBillenium.
	self assert: timestamp = billenium.
	self assert: billenium asUnixTime = 1000000000