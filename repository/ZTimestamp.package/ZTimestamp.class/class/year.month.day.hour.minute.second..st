instance creation
year: year month: month day: day hour: hour minute: minute second: second
	"Create and return a new ZTimestamp for the Gregorian calendar date described by year, month and date
	and the Civil time of day on that date described by hour, minute and second"

	^ self new
		jdn: (self jdnFromYear: year month: month day: day)
		secs: (hour * 3600) + (minute * 60) + second