parsers
parseYearFourDigitsFrom: stream
	^ #year -> (self readInteger: 4 from: stream)