public
offsetForLocalTimestamp: timestamp
	"Return the offset Duration to be subtracted from timestamp (interpreted as
	local wall time) to get the correct GMT time in the timezone that I represent.
	The offset depends on the point in time (summer/winter time, history).
	All objects that respond to #asUnixTime can serve as a timestamp."
	
	| subzone |
	subzone := self subzoneForLocalTimestamp: timestamp.
	^ subzone offset 