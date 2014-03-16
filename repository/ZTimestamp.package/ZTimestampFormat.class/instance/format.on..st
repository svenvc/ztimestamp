formatting
format: object on: stream
	| local |
	local := self gmtToLocal: object.
	formatter do: [ :each |
		each isCharacter 
			ifTrue: [ stream nextPut: each ] 
			ifFalse: [ self perform: each with: local with: stream ] ]