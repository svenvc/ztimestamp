instance creation
readFrom: stream format: formatSpecification
	"Parse a representation from stream, according to formatSpecification
	and return an instance of me. See ZTimestampFormat for details."

	^ (ZTimestampFormat fromString: formatSpecification)
			readFrom: stream 