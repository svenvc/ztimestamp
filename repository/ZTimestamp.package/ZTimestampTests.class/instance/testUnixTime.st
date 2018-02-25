testing
testUnixTime
	| timestamp billenium |
	timestamp := ZTimestamp fromUnixTime: 1000000000.
	billenium := self unixTimeBillenium.
	self assert: timestamp equals: billenium.
	self assert: billenium asUnixTime equals: 1000000000