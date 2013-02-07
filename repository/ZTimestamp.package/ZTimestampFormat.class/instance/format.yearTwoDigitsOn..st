formatters
format: object yearTwoDigitsOn: stream
	object year \\ 100 printOn: stream base: 10 length: 2 padded: true