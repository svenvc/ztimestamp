testing
testReadAll
	| timezones timezone |
	self checkZoneInfoLocation.
	timezones := ZTimezone timezoneIdentifiers 
		collect: [ :each | ZTimezone readTimezoneWithId: each ].
	self deny: timezones isEmpty.
	timezone := timezones 
		detect: [ :each | each id = #'Europe/Brussels' ]
		ifNone: [ self fail ].
	self assertIsTimezoneEuropeBrussels: timezone