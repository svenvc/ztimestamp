operations
roundtripDelay
	"Return the round trip delay
	as computed using the NTP clock synchronization algorithm"

	| result |
	result := self sync.
	^ result at: #roundtripDelay