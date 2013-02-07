private
readInteger: numberOfDigits atLeastFrom: stream
	"Parse and return a decimal number of at least numberOfDigits from stream.
	Continue reading until a non digit or the end of stream is reached.
	Fail if that is not possible"

	| integer |
	integer := 0.
	numberOfDigits timesRepeat: [ | char |
		char := stream next.
		self assert: ('0123456789' includes: char).
		integer := (integer * 10) + char digitValue ].
	[ stream atEnd not and: [ stream peek isDigit ] ] whileTrue: [
		integer := (integer * 10) + stream next digitValue ].
	^ integer