accessing
month
	"Return the month of the receiver, according to the Gregorian calendar, a number between 1 and 12"

	^ self dayMonthYearDo: [ :day :month :year | month ]