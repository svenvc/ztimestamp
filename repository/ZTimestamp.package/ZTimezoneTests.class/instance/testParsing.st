testing
testParsing
	| timezone |
	timezone := ZTimezone fromStream: self europeBrusselsContents readStream.
	self assert: timezone transitions size equals: 185.
	self assert: timezone subzones size equals: 10.
	self assertIsTimezoneEuropeBrussels: timezone