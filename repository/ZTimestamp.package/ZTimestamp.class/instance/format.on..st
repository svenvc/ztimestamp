printing
format: formatSpecification on: stream
	"Write a string representation of me according to formatSpecification on stream.
	See ZTimestampFormat for details."

	^ (ZTimestampFormat fromString: formatSpecification)
			format: self on: stream