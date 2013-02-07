formatters
format: object dayTwoDigitsSpacePaddedOn: stream
	object dayOfMonth < 10
		ifTrue: [ stream space ].
	object dayOfMonth printOn: stream