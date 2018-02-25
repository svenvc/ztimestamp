testing
testSorting
	| array sorted now |
	now := ZTimestamp now.
	array := { now. self lunarLanding. self marsLanding. self unixTimeBillenium }.
	sorted := array sorted.
	self assert: sorted first equals: self lunarLanding.
	self assert: sorted last equals: now