testing
testEpoch
	| epoch |
	epoch := ZTimestamp epoch.
	self assert: epoch equals: ZTimestamp zero.
	self assert: epoch julianDayNumber equals: 0.
	self assert: epoch secondsSinceMidnight equals: 0.
	"astronomical year to proleptic Gregorian year"
	self assert: epoch year - 1 equals: -4713
	