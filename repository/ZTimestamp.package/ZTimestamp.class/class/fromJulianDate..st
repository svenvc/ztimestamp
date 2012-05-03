instance creation
fromJulianDate: julianDate
	"Create and return a new ZTimestamp instance from the scientific Julian Date, a Float number of Julian Days"
	
	^ self new
		jdn: julianDate truncated
		secs: (julianDate fractionPart * 86400) truncated
		