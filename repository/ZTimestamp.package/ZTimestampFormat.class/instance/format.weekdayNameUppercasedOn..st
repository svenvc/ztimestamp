formatters
format: object weekdayNameUppercasedOn: stream
	stream << (self weekdayNames at: object dayOfWeek) asUppercase 