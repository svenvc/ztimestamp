accessing
dayMonthYearDo: block
	"Compute and return the Julian Day Number from the Gregorian Calender date described by year, month and day.
	See http://en.wikipedia.org/wiki/Julian_date#Converting_Gregorian_calendar_date_to_Julian_Day_Number"

	^ self class 
		withJdn: jdn dayMonthYearDo: block