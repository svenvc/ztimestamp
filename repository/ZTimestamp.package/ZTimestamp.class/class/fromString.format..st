instance creation
fromString: string format: formatSpecification
	"Parse and return an instance from the string representation 
	according to formatSpecification, see #readFrom:format:" 

	^ self readFrom: string readStream format: formatSpecification