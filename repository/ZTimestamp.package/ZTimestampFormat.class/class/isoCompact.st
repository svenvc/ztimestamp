accessing
isoCompact
	"The standard ISO 8601 date/time format with minimal separators and implied timezone UTC"
	"YYYYMMDDTHHMMSS"
	"ZTimestampFormat isoCompact format: ZTimestamp now"

	^ self fromString: '20010203T160506'