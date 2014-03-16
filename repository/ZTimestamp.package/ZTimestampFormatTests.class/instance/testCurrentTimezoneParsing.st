testing
testCurrentTimezoneParsing
	| format winter summer |
	winter := ZTimestamp year: 2014 month: 1 day: 1 hour: 11 minute: 0 second: 0.
	summer := ZTimestamp year: 2014 month: 8 day: 1 hour: 11 minute: 0 second: 0.
	ZCurrentTimezone 
		value: (ZTimezone id: #'Europe/Brussels')
		during: [ 
			format := ZTimestampFormat fromString: '2001-02-03T16:05'.
			format useCurrentTimezone.
			self 
				assert: (format parse: '2014-01-01T12:00')
				equals: winter.
			self 
				assert: (format parse: '2014-08-01T13:00')
				equals: summer.
			format specification: '2001-02-03T16:05+00:00'.
			self 
				assert: (format parse: '2014-01-01T16:00+05:00')
				equals: winter.
			self 
				assert: (format parse: '2014-08-01T15:00+04:00')
				equals: summer ]