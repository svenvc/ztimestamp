testing
< aZTimestamp
	"Answer true when aZTimestamp is strictly later than me, false otherwise.
	Part of the Magnitude protocol"
	
	^ jdn = aZTimestamp julianDayNumber
		ifTrue: [ secs < aZTimestamp secondsSinceMidnight ]
		ifFalse: [ jdn < aZTimestamp julianDayNumber ]