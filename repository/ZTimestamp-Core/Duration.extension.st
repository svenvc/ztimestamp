Extension { #name : #Duration }

{ #category : #'*ZTimestamp-Core' }
Duration >> subtractFromTimestamp: timestamp [
	"Part of the double dispatch implementation of ZTimestamp>>#-"
	
	^ timestamp subtractDuration: self
]
