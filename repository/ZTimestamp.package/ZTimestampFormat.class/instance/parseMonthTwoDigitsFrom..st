parsers
parseMonthTwoDigitsFrom: stream
	^ #month -> (self readInteger: 2 from: stream)