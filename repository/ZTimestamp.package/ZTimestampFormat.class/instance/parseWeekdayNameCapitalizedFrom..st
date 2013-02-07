parsers
parseWeekdayNameCapitalizedFrom: stream
	| match |
	match := self readAny: self weekdayNames sorted from: stream.
	self assert: match notNil.
	^ #weekday -> (self weekdayNames indexOf: match)