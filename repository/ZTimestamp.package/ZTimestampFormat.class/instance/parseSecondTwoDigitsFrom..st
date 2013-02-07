parsers
parseSecondTwoDigitsFrom: stream
	^ #second -> (self readInteger: 2 from: stream)