parsers
parseSecondFrom: stream
	^ #second -> (self readInteger: 1 atLeastFrom: stream)