parsers
parseWeekdayNameUppercasedFrom: stream
	| match |
	match := self 
		readAny: (self weekdayNames collect: [ :each | each asUppercase ]) sorted 
		from: stream.
	self assert: match notNil.
	^ #weekday -> (self weekdayNames indexOf: match asLowercase capitalized)