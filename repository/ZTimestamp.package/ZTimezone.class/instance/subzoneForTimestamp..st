public
subzoneForTimestamp: timestamp
	"Return the ZSubTimezone instance for timestamp (interpreted as GMT)
	to get the correct local wall time in the timezone that I represent.
	The returned object knows the offet Duration to be added, the timezone 
	abbreviation and whether daylight saving was in effect or not.
	The subzone depends on the point in time (summer/winter time, history).
	All objects that respond to #asUnixTime can serve as a timestamp."

	^ self subzoneForUnixTime: timestamp asUnixTime 