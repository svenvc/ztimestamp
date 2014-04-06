formatters
format: object timeZoneAbbreviatedOn: stream
	object offset isZero
		ifTrue: [ stream << #UTC ]
		ifFalse: [ stream << (self abbreviationForTimeZoneOffset: object offset) ]