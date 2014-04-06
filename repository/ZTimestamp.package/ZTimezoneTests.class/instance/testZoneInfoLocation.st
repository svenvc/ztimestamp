testing
testZoneInfoLocation
	self runningOnWindows ifTrue: [ self skip ].
	self assert: ZTimezone zoneInfoLocation exists