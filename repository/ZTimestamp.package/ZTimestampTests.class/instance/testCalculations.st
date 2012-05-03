testing
testCalculations
	| delta |
	delta := self marsLanding - self lunarLanding.
	self assert: delta > Duration zero.
	self assert: self lunarLanding + delta equals: self marsLanding.
	self assert: self marsLanding - delta equals: self lunarLanding