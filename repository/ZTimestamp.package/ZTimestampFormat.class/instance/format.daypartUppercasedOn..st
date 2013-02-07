formatters
format: object daypartUppercasedOn: stream
	stream << (object hour < 12 ifTrue: [ #AM ] ifFalse: [ #PM ])