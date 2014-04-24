*ztimestamp
subtractFromTimestamp: timestamp
	"Part of the double dispatch implementation of ZTimestamp>>#-"
	
	^ timestamp subtractTimestamp: self asZTimestamp