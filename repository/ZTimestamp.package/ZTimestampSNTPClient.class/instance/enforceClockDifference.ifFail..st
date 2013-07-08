operations
enforceClockDifference: duration ifFail: block 
	"Check the difference between the remote and local clock,
	and execute block if it is larger than duration."
	
	| difference |
	difference := self clockDifference.
	difference > duration
		ifTrue: [ block cull: difference ]