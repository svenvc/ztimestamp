parsers
parseYearTwoDigitsFrom: stream
	^ #year -> (2000 + (self readInteger: 2 from: stream))