testing
testHashing
	| array set now |
	now := ZTimestamp now.
	array := { now. self lunarLanding. self marsLanding. self unixTimeBillenium }.
	set := array asSet.
	self assert: array size = set size.
	array do: [ :each |
		self assert: (set includes: each) ].
	set addAll: array.
	self assert: array size = set size.
	array do: [ :each |
		self assert: (set includes: each) ].