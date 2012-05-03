initialize-release
jdn: julianDayNumber secs: secondsSinceMidnight
	"Initialize the receiver with julianDayNumber and secondsSinceMidnight,
	then normalize so that secondsSinceMidnight is within the expected range"
	
	jdn := julianDayNumber.
	secs := secondsSinceMidnight.
	self normalize