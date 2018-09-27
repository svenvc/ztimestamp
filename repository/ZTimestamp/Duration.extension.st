Extension { #name : #Duration }

{ #category : #'*ztimestamp' }
Duration >> subtractFromTimestamp: timestamp [
	"Part of the double dispatch implementation of ZTimestamp>>#-"
	
	^ timestamp subtractDuration: self
]
