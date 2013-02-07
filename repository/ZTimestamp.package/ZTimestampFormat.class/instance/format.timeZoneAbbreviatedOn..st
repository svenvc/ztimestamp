formatters
format: object timeZoneAbbreviatedOn: stream
	object offset isZero
		ifTrue: [ stream << #UTC ]
		ifFalse: [ stream << (TimeZone offset: object offset) abbreviation ]