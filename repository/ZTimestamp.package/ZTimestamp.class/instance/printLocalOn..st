printing
printLocalOn: stream
	"Print the receiver on stream in ISO 8601 extended format in the local timezone"
	
	self 
		printOn: stream 
		format: #($- $T $: nil) 
		timezone: self class localTimeZone offset