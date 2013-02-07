formatters
format: object monthNameAbbreviatedLowercasedOn: stream
	stream << ((self monthNames at: object month) copyFrom: 1 to: 3) asLowercase 