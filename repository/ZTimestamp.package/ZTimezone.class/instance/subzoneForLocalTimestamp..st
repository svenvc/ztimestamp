public
subzoneForLocalTimestamp: timestamp
	"Return the ZSubTimezone instance for timestamp (interpreted as local wall time)
	to get the correct GMT time in the timezone that I represent.
	The returned object knows the offet Duration to be subtracted, 
	the timezone abbreviation and whether daylight saving was in effect or not.
	The subzone depends on the point in time (summer/winter time, history).
	All objects that respond to #asUnixTime can serve as a timestamp."

	^ self subzoneForLocalUnixTime: timestamp asUnixTime 