instance creation
fromUnixTime: integer
	"Create and return a new ZTimestamp from the integer number of seconds since the Unix or POSIX epoch"
	
	^ self unixEpoch + integer seconds
