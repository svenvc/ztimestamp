converting
asDateAndTime 
	"Convert the receiver to a DateAndTime.
	Note that I ame in the UTC/GMT/Zulu timezone and have second precision"
	
	^ DateAndTime new
		setJdn: jdn 
		seconds: secs 
		nano: 0 
		offset: self offset