parsers
parseMonthNameLowercasedFrom: stream
	| match |
	match := self 
		readAny: (self monthNames collect: [ :each | each asLowercase ]) sorted 
		from: stream.
	self assert: match notNil.
	^ #month -> (self monthNames indexOf: match capitalized)