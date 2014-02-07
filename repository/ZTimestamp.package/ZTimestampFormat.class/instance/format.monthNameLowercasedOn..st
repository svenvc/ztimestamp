formatters
format: object monthNameLowercasedOn: stream
	stream << (self monthNames at: object monthIndex) asLowercase 