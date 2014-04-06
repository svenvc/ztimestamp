formatters
format: object timeZoneAbbreviatedOn: stream
	| offset |
	offset := self actualOffsetForTimestamp: object.
	offset isZero
		ifTrue: [ stream << #UTC ]
		ifFalse: [ stream << (self abbreviationForTimeZoneOffset: offset) ]