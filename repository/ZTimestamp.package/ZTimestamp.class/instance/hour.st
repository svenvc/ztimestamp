accessing
hour
	"Return the number of hours in the receiver, according to Civil time, a number between 0 and 23"

	^ (secs \\ 86400) // 3600