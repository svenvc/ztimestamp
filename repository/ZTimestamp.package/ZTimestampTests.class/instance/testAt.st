testing
testAt
	self assert: ZTimestamp @ '1969-07-20T20:17:40Z' equals: self lunarLanding.
	self assert: ZTimestamp @ '19690720T201740' equals: self lunarLanding.
	self assert: ZTimestamp @ '19690720' equals: self lunarLanding asBeginOfDay