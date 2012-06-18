accessing
unixEpoch
	"Return the Unix or POSIX epoch as a ZTimestamp"
	
	^ UnixEpoch 
		ifNil: [ UnixEpoch := self year: 1970 month: 1 day: 1 ]