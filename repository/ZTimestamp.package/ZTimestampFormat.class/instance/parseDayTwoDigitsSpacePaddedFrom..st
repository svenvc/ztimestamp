parsers
parseDayTwoDigitsSpacePaddedFrom: stream
	^ #day -> (self readInteger: 2 optionalSpaceFrom: stream)