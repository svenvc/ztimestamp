testing
testParseEpoch
	| epoch |
	epoch := ZTimestamp epoch.
	self assert: (ZTimestamp fromString: epoch asString) equals: epoch