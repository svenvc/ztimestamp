accessing
dayOfWeekName
	"Return the English name of the day of the week of the receiver, according to the Gregorian calendar, a Symbol"

	^ #(Sunday Monday Tuesday Wednesday Thursday Friday Saturday) at: self dayOfWeek