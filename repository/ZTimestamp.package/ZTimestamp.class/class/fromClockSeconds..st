private
fromClockSeconds: seconds
	"Create and return a new instance from a specific number of seconds since our clock epoch, see #now"
	
	^ self new
		jdn: self clockEpoch julianDayNumber + (seconds // 86400)
		secs: self clockEpoch secondsSinceMidnight + (seconds \\ 86400)
	