operations
localClockOffset
	"Return a Delay representing the local clock offiset 
	as computed using the NTP clock synchronization algorithm"

	| result |
	result := self sync.
	^ result at: #localClockOffset