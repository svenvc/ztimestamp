testing
testReferenceDateAndTime
	| reference format now |
	reference := ZTimestampFormat reference12 asDateAndTime.
	(format := ZTimestampFormat fromString: reference printString)
		createDateAndTime.
	self assert: (format format: reference) equals: reference printString.
	self assert: (format parse: reference printString) equals: reference.
	reference := ZTimestampFormat reference24 asDateAndTime.
	(format := ZTimestampFormat fromString: reference printString)
		createDateAndTime.
	self assert: (format format: reference) equals: reference printString.
	self assert: (format parse: reference printString) equals: reference.
	now := DateAndTime now truncated.
	self assert: (format format: now) equals: now printString.
	self assert: (format parse: now printString) equals: now.
	