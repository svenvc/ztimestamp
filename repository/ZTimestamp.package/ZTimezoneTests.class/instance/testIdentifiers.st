testing
testIdentifiers
	self checkZoneInfoLocation.
	self deny: ZTimezone timezoneIdentifiers isEmpty.
	self assert: (ZTimezone timezoneIdentifiers includes: #'Europe/Brussels')