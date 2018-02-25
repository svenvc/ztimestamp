formatters
format: object nanosecondOn: stream
	| n len |
	n := object nanoSecond.
	n ~=0
		ifTrue: [  
			len := 9.
			[ n \\ 10 = 0 ] whileTrue: [ 
				n := n / 10.
				len := len - 1 ] ] 
		ifFalse: [ len := 1 ].
	n printOn: stream base: 10 length: len padded: true