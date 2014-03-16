testing
testCurrentTimezoneFormatting
	| format winter summer |
	winter := ZTimestamp year: 2014 month: 1 day: 1 hour: 11 minute: 0 second: 0.
	summer := ZTimestamp year: 2014 month: 8 day: 1 hour: 11 minute: 0 second: 0.
	ZCurrentTimezone 
		value: (ZTimezone id: #'Europe/Brussels')
		during: [ 
			format := ZTimestampFormat iso.
			format useCurrentTimezone.
			self 
				assert: (format format: winter)
				equals: '2014-01-01T12:00:00+01:00'.
			self 
				assert: (format format: summer)
				equals: '2014-08-01T13:00:00+02:00'.
			format specification: '20010203T1605'.
			self 
				assert: (format format: winter)
				equals: '20140101T1200'.
			self 
				assert: (format format: summer)
				equals: '20140801T1300' ]