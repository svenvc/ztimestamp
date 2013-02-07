formatters
format: object weekdayNameAbbreviatedCapitalizedOn: stream
	stream << ((self weekdayNames at: object dayOfWeek) copyFrom: 1 to: 3)