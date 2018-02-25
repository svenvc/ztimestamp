parsing
readFrom: stream
	"Parse stream according to my specification and return an instance as created by my constructor"

	| elements |
	elements := SmallDictionary new.
	parser do: [ :each |
		each isCharacter 
			ifTrue: [ self assert: stream next = each ]
			ifFalse: [ elements add: (self perform: each with: stream) ] ].
	^ self createInstanceFrom: elements