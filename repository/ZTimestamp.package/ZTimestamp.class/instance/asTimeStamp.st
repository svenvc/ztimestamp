converting
asTimeStamp 
	"Convert the receiver to a TimeStamp.
	Note that I am in the UTC/GMT/Zulu timezone and have second precision"

	^ TimeStamp new
		setJdn: jdn 
		seconds: secs 
		nano: 0 
		offset: self offset