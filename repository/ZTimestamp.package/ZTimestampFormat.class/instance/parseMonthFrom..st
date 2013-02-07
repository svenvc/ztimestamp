parsers
parseMonthFrom: stream
	^ #month -> (self readInteger: 1 atLeastFrom: stream)