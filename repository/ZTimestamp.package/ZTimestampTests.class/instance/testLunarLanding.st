testing
testLunarLanding
	| timestamp |
	timestamp := self lunarLanding.
	self assertInvariants: timestamp.
	self assert: timestamp monthName equals: #July.
	self assert: timestamp dayOfWeekName equals: #Sunday.
	self assert: timestamp dayOfYear equals: 201.