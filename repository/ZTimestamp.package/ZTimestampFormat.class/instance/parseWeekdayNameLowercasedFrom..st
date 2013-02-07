parsers
parseWeekdayNameLowercasedFrom: stream
	| match |
	match := self 
		readAny: (self weekdayNames collect: [ :each | each asLowercase ]) sorted 
		from: stream.
	self assert: match notNil.
	^ #weekday -> (self weekdayNames indexOf: match capitalized)