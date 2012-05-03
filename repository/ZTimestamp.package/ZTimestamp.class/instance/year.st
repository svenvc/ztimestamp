accessing
year
	"Return the year of the receiver, according to the Gregorian calendar, an Integer"

	^ self dayMonthYearDo: [ :day :month :year | year ]