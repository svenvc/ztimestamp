testing
< aZTimestamp
	"Answer true when aZTimestamp is strictly later than me, false otherwise.
	Part of the Magnitude protocol"
	
	^ aZTimestamp julianDayNumber = jdn
		ifTrue: [ secs < aZTimestamp secondsSinceMidnight ]
		ifFalse: [ jdn < aZTimestamp julianDayNumber ]