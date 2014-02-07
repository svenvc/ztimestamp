formatters
format: object monthNameUppercasedOn: stream
	stream << (self monthNames at: object monthIndex) asUppercase 