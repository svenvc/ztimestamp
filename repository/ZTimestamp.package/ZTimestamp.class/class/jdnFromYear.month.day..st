accessing
jdnFromYear: year month: month day: day
	"Compute and return the Julian Day Number from the Gregorian Calender date described by year, month and day.
	See http://en.wikipedia.org/wiki/Julian_date#Converting_Gregorian_calendar_date_to_Julian_Day_Number"
	 
	| a y m |
	a := (14 - month) // 12.
	y := year + 4800 - a.
	m := month + (12 * a) - 3.
	^ day 
		+ (((153 * m) + 2) // 5) 
		+ (365 * y)
		+ (y // 4)
		- (y // 100)
		+ (y // 400)
		- 32045