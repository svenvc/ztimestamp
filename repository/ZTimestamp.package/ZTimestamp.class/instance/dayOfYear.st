accessing
dayOfYear
	"Return the day of the year of the receiver, according to the Gregorian calendar, a number between 1 and 365"

	^ self dayMonthYearDo: [ :day :month :year | | monthStart |
		monthStart := #(1 32 60 91 121 152 182 213 244 274 305 335) at: month.
		(month > 2 and: [ Year isLeapYear: year ])
			ifTrue: [ monthStart + day ]
			ifFalse: [ monthStart + day - 1 ] ]