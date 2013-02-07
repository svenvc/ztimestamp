parsers
parseDayFrom: stream
	^ #day -> (self readInteger: 1 atLeastFrom: stream)