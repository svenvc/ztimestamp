parsers
parseMinuteFrom: stream
	^ #minute -> (self readInteger: 1 atLeastFrom: stream)