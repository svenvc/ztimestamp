accessing
dayOfMonth
	"Return the day of the month of the receiver, according to the Gregorian calendar, a number between 1 and 31"

	^ self dayMonthYearDo: [ :day :month :year | day ]