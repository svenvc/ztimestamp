instance creation
now
	"Create and return a new ZTimestamp equal to the current system time"
	
	^ self fromClockSeconds: (self clockSeconds - self clockTimezoneOffset)