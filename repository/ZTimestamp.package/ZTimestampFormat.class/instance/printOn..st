printing
printOn: stream
	super printOn: stream.
	stream nextPut: $(.
	stream << specification.
	stream nextPut: $)