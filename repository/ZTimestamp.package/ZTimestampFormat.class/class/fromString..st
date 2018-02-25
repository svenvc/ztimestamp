instance creation
fromString: example
	"Create an instance of me, based on the example."
	
	^ self new
		specification: example;
		yourself
	