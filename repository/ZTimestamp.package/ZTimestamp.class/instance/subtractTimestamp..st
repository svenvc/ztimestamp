arithmetic
subtractTimestamp: timestamp
	"Part of the double dispatch implementation of ZTimestamp>>#-"
	
	^ Duration seconds: 
			((jdn - timestamp julianDayNumber) * 86400) 
			+ (secs - timestamp secondsSinceMidnight)