parsers
parseTimeZoneAbbreviatedFrom: stream
	^ #offset -> (TimeZone abbreviated: (stream next: 3)) offset