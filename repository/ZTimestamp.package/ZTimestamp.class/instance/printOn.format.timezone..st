printing
printOn: stream format: format timezone: timezone
	"Print an ISO representation in timezone and adding it as [+|-]HH:MM"

	self assert: (format at: 4) isNil.
	(self + timezone asDuration) printOn: stream format: format.
	stream nextPut: (timezone positive ifTrue: [ $+ ] ifFalse: [ $- ]).
	timezone hours abs printOn: stream base: 10 length: 2 padded: true.
	(format at: 3) ifNotNil: [ :separator | stream nextPut: separator ].
	timezone minutes printOn: stream base: 10 length: 2 padded: true