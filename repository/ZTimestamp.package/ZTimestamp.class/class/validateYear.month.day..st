private
validateYear: year month: month day: day
	| daysInMonth message |
	year isInteger
		ifFalse: [ DateError signal: 'Year should be an integer, not ' , year printString ].
	(month isInteger and: [ month between: 1 and: 12 ])
		ifFalse: [ DateError signal: 'Month should be an integer between 1 and 12, not ' , month printString ].
	daysInMonth := Month daysInMonth: month forYear: year.
	(day isInteger and: [ day between: 1 and: daysInMonth ])
		ifFalse: [ 
			message := 'Day should be an integer between 1 and {1}, the number of days in month {2} of year {3}, not {4}' 
				format: { daysInMonth. month. year. day printString }.
			DateError signal: message ]