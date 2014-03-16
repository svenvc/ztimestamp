testing
testEuropeBrussels
	| timezone |
	timezone := ZTimezone id: #'Europe/Brussels'.
	self assert: timezone id equals: #'Europe/Brussels'.
	self assertIsTimezoneEuropeBrussels: timezone