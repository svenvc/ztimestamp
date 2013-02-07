formatters
format: object weekdayNameLowercasedOn: stream
	stream << (self weekdayNames at: object dayOfWeek) asLowercase 