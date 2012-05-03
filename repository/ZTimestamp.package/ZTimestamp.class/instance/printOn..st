printing
printOn: stream
	"Print the receiver on stream in ISO 8601 extended format"
	
	self 
		printOn: stream 
		format: #($- $T $: $Z)