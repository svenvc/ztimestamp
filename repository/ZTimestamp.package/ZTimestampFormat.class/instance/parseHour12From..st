parsers
parseHour12From: stream
	^ #hour -> (self readInteger: 1 atLeastFrom: stream)