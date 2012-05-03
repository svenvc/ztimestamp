testing
testJulianDate
	| now julianDate |
	now := ZTimestamp now.
	julianDate := now julianDate.
	self assert: (ZTimestamp fromJulianDate: julianDate) - now < 1 second