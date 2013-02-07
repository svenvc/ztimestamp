formatters
format: object monthNameUppercasedOn: stream
	stream << (self monthNames at: object month) asUppercase 