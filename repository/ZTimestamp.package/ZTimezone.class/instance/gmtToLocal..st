convenience
gmtToLocal: timestamp
	"Return a copy of timestamp shifted from GMT to 
	the local wall time as defined by the receiver.
	This works as long as timestamp understands #asUnixTime and #+"

	| offset |
	offset := self offsetForTimestamp: timestamp.
	^ timestamp + offset