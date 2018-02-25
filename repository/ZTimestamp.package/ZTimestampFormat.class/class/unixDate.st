accessing
unixDate
	"Unix format as used by the date command line command"
	"WeekdayNameAbbreviated MonthNameAbbreviated DayInMonth HH:MM:SS TimezoneAbbreviated Year"
	"ZTimestampFormat unixDate format: ZTimestamp now"
	
	^ self fromString: 'Sat Feb _3 16:05:06 UTC 2001'