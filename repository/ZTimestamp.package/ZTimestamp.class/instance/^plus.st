arithmetic
+ operand
	"Return a new ZTimestamp that is the result of adding
	the operand considered as a Duration to the receiver"
	
	^ self class new
		jdn: jdn
		secs: secs + operand asDuration asSeconds