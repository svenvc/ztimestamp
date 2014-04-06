accessing
withNowDo: block
	"Evaluate block with 2 arguments: ZTimestamp now and the residual microseconds.
	Return the value of block. Works only on Pharo 3.0 and higher."
	
	"self withNowDo: [ :timestamp :microseconds | { timestamp. microseconds } ]"
	
	| microsecondClockValue totalSeconds |
	microsecondClockValue := Time microsecondClockValue.
	totalSeconds := microsecondClockValue // 1e6.
	^ block 
		cull: (self fromClockSeconds: totalSeconds - self clockTimezoneOffset)
		cull: microsecondClockValue - (totalSeconds * 1e6)