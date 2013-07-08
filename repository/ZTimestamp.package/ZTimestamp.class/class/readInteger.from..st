private
readInteger: numberOfDigits from: stream
	"Parse and return a decimal number of numberOfDigits from stream.
	Fail if that is not possible"

	| integer |
	integer := 0.
	numberOfDigits timesRepeat: [ | char |
		char := stream next.
		('0123456789' includes: char)
			ifTrue: [ integer := (integer * 10) + char digitValue ]
			ifFalse: [ self error: 'Decimal digit expected' ] ].
	^ integer