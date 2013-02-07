parsers
parseDayTwoDigitsFrom: stream
	^ #day -> (self readInteger: 2 from: stream)