testing
testLunarLanding
	| timestamp |
	timestamp := self lunarLanding.
	self assertInvariants: timestamp.
	self assert: timestamp monthName = #July.
	self assert: timestamp dayOfWeekName = #Sunday.
	self assert: timestamp dayOfYear = 201.