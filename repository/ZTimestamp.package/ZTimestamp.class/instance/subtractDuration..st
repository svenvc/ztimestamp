arithmetic
subtractDuration: duration
	"Part of the double dispatch implementation of ZTimestamp>>#-"
	
	^ self + duration negated