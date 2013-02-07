formatters
format: object monthNameAbbreviatedCapitalizedOn: stream
	stream << ((self monthNames at: object month) copyFrom: 1 to: 3)