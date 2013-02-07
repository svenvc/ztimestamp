parsers
parseHour12TwoDigitsFrom: stream
	^ #hour -> (self readInteger: 2 from: stream)