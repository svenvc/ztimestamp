accessing
minute
	"Return the number of minutes in the receiver after full hours have been removed, 
	according to Civil Time, a number between 0 and 59"

	^ (secs \\ 3600) // 60