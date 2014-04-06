testing
testIdentifiers
	self runningOnWindows ifTrue: [ self skip ].
	self deny: ZTimezone timezoneIdentifiers isEmpty.
	self assert: (ZTimezone timezoneIdentifiers includes: #'Europe/Brussels')