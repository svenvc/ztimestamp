formatters
format: object weekdayNameCapitalizedOn: stream
	stream << (self weekdayNames at: object dayOfWeek)