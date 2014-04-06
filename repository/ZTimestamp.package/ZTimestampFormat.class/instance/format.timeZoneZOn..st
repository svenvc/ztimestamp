formatters
format: object timeZoneZOn: stream
	| offset |
	offset := self actualOffsetForTimestamp: object.
	offset isZero
		ifTrue: [ stream nextPut: $Z ]
		ifFalse: [ 
			stream nextPut: (offset positive ifTrue: [ $+ ] ifFalse: [ $- ]).
			offset hours abs
				printOn: stream base: 10 length: 2 padded: true.
			stream nextPut: $:.
			offset minutes
				printOn: stream base: 10 length: 2 padded: true ]