formatters
format: object weekdayNameAbbreviatedUppercasedOn: stream
	stream << ((self weekdayNames at: object dayOfWeek) copyFrom: 1 to: 3) asUppercase 