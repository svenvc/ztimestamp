formatting
format: object
	"Format object according to my specification and return a string"
	
	^ String streamContents: [ :stream |
			self format: object on: stream ]