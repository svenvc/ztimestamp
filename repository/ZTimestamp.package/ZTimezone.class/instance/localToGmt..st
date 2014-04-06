convenience
localToGmt: timestamp
	"Return a copy of timestamp shifted from the local wall time 
	as defined by the receiver to GMT.
	This works as long as timestamp understands #asUnixTime and #-"

	| offset |
	offset := self offsetForLocalTimestamp: timestamp.
	^ timestamp - offset