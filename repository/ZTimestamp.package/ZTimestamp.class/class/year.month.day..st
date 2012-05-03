instance creation
year: year month: month day: day
	"Create and return a new ZTimestamp for the Gregorian calendar date described by year, month and date"
	
	^ self new
		jdn: (self jdnFromYear: year month: month day: day)
		secs: 0