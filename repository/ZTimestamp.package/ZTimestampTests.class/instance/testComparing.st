testing
testComparing
	self assertInvariants: self marsLanding.
	self deny: self lunarLanding = self marsLanding.
	self assert: self lunarLanding < self marsLanding.