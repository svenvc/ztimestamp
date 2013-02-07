parsers
parseTimeZoneFrom: stream
	^ #offset -> (ZTimestamp readTimezoneOffsetFrom: stream) seconds