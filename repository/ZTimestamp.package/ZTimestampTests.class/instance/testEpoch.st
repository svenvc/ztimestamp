testing
testEpoch
	| epoch |
	epoch := ZTimestamp epoch.
	self assert: epoch equals: ZTimestamp zero.
	self assert: epoch julianDayNumber equals: 0.
	self assert: epoch secondsSinceMidnight equals: 0.
	"astronomical year to proleptic Gregorian year"
	self assert: epoch year equals: -4713.
	self assert: epoch month equals: 11.
	self assert: epoch dayOfMonth equals: 24.
	