arithmetic
- operand
	"For ZTimestamp compatible operands, return a new Duration 
	equal to the difference between the reveiver and the operand.
	Else return a new ZTimestamp that is the result of subtracting 
	the operand considered as a Duration from the receiver.
	Implemented using double dispatch."
	
	^ operand subtractFromTimestamp: self