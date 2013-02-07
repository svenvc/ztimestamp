parsers
parseMinuteTwoDigitsFrom: stream
	^ #minute -> (self readInteger: 2 from: stream)