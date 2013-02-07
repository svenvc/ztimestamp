private
readInteger: numberOfDigits optionalSpaceFrom: stream
	"Parse and return a decimal number of numberOfDigits from stream.
	There can be one optional space instead of a digit at the beginning.
	Fail if that is not possible"

	^ stream peek = $ 
		ifTrue: [ 
			stream next. 
			self readInteger: numberOfDigits - 1 from: stream ]
		ifFalse: [
			self readInteger: numberOfDigits from: stream ]