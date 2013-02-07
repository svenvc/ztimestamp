converting
asEndOfDay
	"Return a timestamp at the end of the day that I represent"
	
	^ self class new
		jdn: jdn secs: 86399