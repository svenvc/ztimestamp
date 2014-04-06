printing
printOn: stream
	super printOn: stream.
	stream nextPut: $(.
	stream << abbreviation; space; print: offset.
	isDaylightSaving ifTrue: [ stream << ' DST' ]. 
	stream nextPut: $)