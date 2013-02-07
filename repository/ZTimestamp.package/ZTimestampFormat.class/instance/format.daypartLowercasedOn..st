formatters
format: object daypartLowercasedOn: stream
	stream << (object hour < 12 ifTrue: [ #am ] ifFalse: [ #pm ])