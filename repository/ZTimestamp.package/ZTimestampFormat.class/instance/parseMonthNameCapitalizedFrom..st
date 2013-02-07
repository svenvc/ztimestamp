parsers
parseMonthNameCapitalizedFrom: stream
	| match |
	match := self readAny: self monthNames sorted from: stream.
	self assert: match notNil.
	^ #month -> (self monthNames indexOf: match)