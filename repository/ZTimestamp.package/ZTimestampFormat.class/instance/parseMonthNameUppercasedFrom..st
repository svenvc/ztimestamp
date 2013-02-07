parsers
parseMonthNameUppercasedFrom: stream
	| match |
	match := self 
		readAny: (self monthNames collect: [ :each | each asUppercase ]) sorted 
		from: stream.
	self assert: match notNil.
	^ #month -> (self monthNames indexOf: match asLowercase capitalized)