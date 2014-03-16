testing
assertIsTimezoneEuropeBrussels: timezone
	| winter summer |
	winter := ZTimestamp year: 2014 month: 01 day: 02.
	self assert: (timezone offsetForTimestamp: winter) equals: 1 hour.
	self assert: (timezone subzoneForTimestamp: winter) abbreviation equals: #CET.
	self deny: (timezone subzoneForTimestamp: winter) isDaylightSaving.
	summer := ZTimestamp year: 2014 month: 08 day: 02.
	self assert: (timezone offsetForTimestamp: summer) equals: 2 hours.
	self assert: (timezone subzoneForTimestamp: summer) abbreviation equals: #CEST.
	self assert: (timezone subzoneForTimestamp: summer) isDaylightSaving