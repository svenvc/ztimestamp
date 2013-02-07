printing
format: formatSpecification
	"Return a string representation of me according to formatSpecification.
	See ZTimestampFormat for details."
	
	^ (ZTimestampFormat fromString: formatSpecification)
			format: self