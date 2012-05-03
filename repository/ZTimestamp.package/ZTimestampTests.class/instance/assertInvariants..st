asserting
assertInvariants: timestamp
	self assert: (timestamp isKindOf: ZTimestamp).
	self assert: timestamp julianDayNumber isInteger.
	self assert: (timestamp secondsSinceMidnight between: 0 and: (24 * 60 * 60) - 1).
	self assert: timestamp offset = Duration zero