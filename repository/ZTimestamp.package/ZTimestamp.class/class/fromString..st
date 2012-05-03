instance creation
fromString: string
	"Parse and return an instance from a flexible ISO 8601 string representation, see #readFrom:" 

	^ self readFrom: string readStream