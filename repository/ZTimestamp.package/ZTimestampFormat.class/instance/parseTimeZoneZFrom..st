parsers
parseTimeZoneZFrom: stream
	^ #offset -> (ZTimestamp readTimezoneOffsetFrom: stream) seconds