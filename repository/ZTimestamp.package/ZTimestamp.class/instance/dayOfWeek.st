accessing
dayOfWeek
	"Return the day of the week of the receiver, according to the Gregorian calendar, a number between 1 and 7.
	1 = Sunday, 2 = Monday, .. , 7 = Saturday."

	^ ((jdn + 1) \\ 7) + 1