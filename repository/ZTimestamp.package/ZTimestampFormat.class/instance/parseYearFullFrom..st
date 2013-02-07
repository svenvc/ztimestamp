parsers
parseYearFullFrom: stream
	| sign |
	sign := 1.
	stream peek = $-
		ifTrue: [ 
			stream next.
			sign := -1 ].
	^ #year -> (sign * (self readInteger: 4 atLeastFrom: stream))