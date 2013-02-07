formatting
print: object on: stream
	formatter do: [ :each |
		each isCharacter 
			ifTrue: [ stream nextPut: each ] 
			ifFalse: [ self perform: each with: object with: stream ] ]