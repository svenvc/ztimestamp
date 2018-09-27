Extension { #name : #DateAndTime }

{ #category : #'*ztimestamp' }
DateAndTime >> asZTimestamp [
	"Convert the receiver to a ZTimestamp.
	Note that we are implicitly converting to UTC by ignoring the offset.
	Note also that nano seconds are dropped."

	^ ZTimestamp new
		jdn: julianDayNumber 
		secs: seconds
]

{ #category : #'*ztimestamp' }
DateAndTime >> subtractFromTimestamp: timestamp [
	"Part of the double dispatch implementation of ZTimestamp>>#-"
	
	^ timestamp subtractTimestamp: self asZTimestamp
]
