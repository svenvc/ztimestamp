parsers
parseHour24TwoDigitsFrom: stream
	^ #hour -> (self readInteger: 2 from: stream)