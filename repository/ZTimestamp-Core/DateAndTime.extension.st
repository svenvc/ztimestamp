Extension { #name : #DateAndTime }

{ #category : #'*ZTimestamp-Core' }
DateAndTime >> asZTimestamp [
	"Convert the receiver to a ZTimestamp.
	Note that we are implicitly converting to UTC by ignoring the offset."

	^ ZTimestamp new
		jdn: julianDayNumber 
		ns: seconds * 1e9 + nanos
]

{ #category : #'*ZTimestamp-Core' }
DateAndTime >> subtractFromTimestamp: timestamp [
	"Part of the double dispatch implementation of ZTimestamp>>#-"
	
	^ timestamp subtractTimestamp: self asZTimestamp
]
