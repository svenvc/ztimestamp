printing
localPrintString
	"Convencience method to convert the receiver in an ISO 8601 representation using the local timezone"

	^ String streamContents: [ :stream |
		self printLocalOn: stream ]