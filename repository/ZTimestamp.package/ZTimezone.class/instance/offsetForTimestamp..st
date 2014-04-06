public
offsetForTimestamp: timestamp
	"Return the offset Duration to be added to timestamp (interpreted as GMT)
	to get the correct local wall time in the timezone that I represent.
	The offset depends on the point in time (summer/winter time, history).
	All objects that respond to #asUnixTime can serve as a timestamp."
	
	| subzone |
	subzone := self subzoneForTimestamp: timestamp.
	^ subzone offset 