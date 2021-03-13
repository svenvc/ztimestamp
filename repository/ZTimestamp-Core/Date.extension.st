Extension { #name : #Date }

{ #category : #'*ZTimestamp-Core' }
Date >> asZTimestamp [
	"Convert the receiver to a ZTimestamp.
	Note that we are ignoring timezone information 
	and interpret the receiver as an abstract data in UTC"

	^ ZTimestamp year: self year month: self monthIndex day: self dayOfMonth
]
