testing
= aZTimestamp
	"Answer true when aZTimestamp equals the receiver, false otherwise.
	Part of the Magnitude protocol"
	
	self == aZTimestamp ifTrue: [ ^ true ].
	self class = aZTimestamp class ifFalse: [ ^ false ].
	^ jdn = aZTimestamp julianDayNumber
		and: [ secs = aZTimestamp secondsSinceMidnight ]