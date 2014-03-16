testing
testGMT
	| timezone subTimezone |
	timezone := ZTimezone gmt.
	self assert: timezone id equals: #GMT.
	subTimezone := timezone subzoneForTimestamp: ZTimestamp now.
	self assert: subTimezone abbreviation equals: #GMT.
	self assert: subTimezone offset equals: Duration zero.
	self deny: subTimezone isDaylightSaving.
	self assert: (ZTimezone id: #GMT) equals: timezone