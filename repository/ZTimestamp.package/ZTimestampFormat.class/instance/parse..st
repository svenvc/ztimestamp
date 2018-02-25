parsing
parse: string
	"Parse string according to my specification and return an instance as created by my constructor"
	
	^ self readFrom: string readStream