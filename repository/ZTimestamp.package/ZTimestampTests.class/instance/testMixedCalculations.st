testing
testMixedCalculations
	| now delta |
	now := DateAndTime now truncated asUTC.
	delta := now - self lunarLanding.
	self assert: delta > Duration zero.
	self assert: self lunarLanding + delta equals: now asZTimestamp.
	self assert: (self lunarLanding + delta) asDateAndTime equals: now.
	self assert: (now - delta) asZTimestamp equals: self lunarLanding.
	self assert: (now - delta) equals: self lunarLanding asDateAndTime