testing
= aZTimestamp
	"Answer true when aZTimestamp equals the receiver, false otherwise.
	Part of the Magnitude protocol"
	
	self == aZTimestamp ifTrue: [ ^ true ].
	(aZTimestamp isKindOf: self class) ifFalse: [ ^ false ].
	^ aZTimestamp julianDayNumber = jdn
		and: [ aZTimestamp secondsSinceMidnight = secs ]