testing
testMonthNames
	#(english french german dutch) do: [ :language | | format |
		format := ZTimestampFormat fromString: '03-February-2001'.
		format perform: language.
		1 to: 12 do: [ :month | | timestamp |
			timestamp := ZTimestamp year: 2012 month: month day: 10. 
			self 
				assert: (format parse: (format format: timestamp))
				equals: timestamp ] ]