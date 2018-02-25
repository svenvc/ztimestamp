parsers
parseNanosecondFrom: stream
	| fraction power |
	fraction := 0.
	power := 1.
	[ stream atEnd not and: [ stream peek isDigit ] ]
		whileTrue: [ 
			fraction := fraction * 10 + stream next digitValue.
			power := power * 10 ].
	^ #nanosecond -> (fraction / power * 1e9)