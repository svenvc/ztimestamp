parsers
parseTimeZoneAbbreviatedFrom: stream
	^ #offset -> (self offsetForTimeZoneAbbreviation: (stream next: 3))