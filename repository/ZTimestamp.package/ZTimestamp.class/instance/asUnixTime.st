converting
asUnixTime
	"Return the Integer number of seconds since the Unix or POSIX epoch."
	
	^ (self - self class unixEpoch) asSeconds