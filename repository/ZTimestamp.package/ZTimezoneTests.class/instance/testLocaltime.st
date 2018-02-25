testing
testLocaltime
	| timezone subTimezone |
	timezone := ZTimezone localtime.
	self assert: timezone id equals: #localtime.
	subTimezone := timezone subzoneForTimestamp: ZTimestamp now.
	self assert: subTimezone abbreviation equals: #localtime.
	self assert: subTimezone offset equals: ZTimestamp localTimeZone offset.
	self deny: subTimezone isDaylightSaving.
	self assert: (ZTimezone id: #localtime) equals: timezone