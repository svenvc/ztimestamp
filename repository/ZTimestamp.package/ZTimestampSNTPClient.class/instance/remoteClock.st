operations
remoteClock
	"Return a timstamp with the value of the remote clock,
	more specifically the transmit timestamp of the NTP server"

	| result |
	result := self sync.
	^ result at: #timestamp