testing
testWeekdayNames
	| timestamp |
	timestamp := ZTimestamp year: 2012 month: 11 day: 3. 
	#(english french german dutch) do: [ :language | | format |
		format := ZTimestampFormat fromString: 'Saterday, 03-Feb-2001'.
		format perform: language.
		1 to: 7 do: [ :weekday |
			self 
				assert: (format parse: (format format: timestamp + weekday days))
				equals: (timestamp + weekday days) ] ]