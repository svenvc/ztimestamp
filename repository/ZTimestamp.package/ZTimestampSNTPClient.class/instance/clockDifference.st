operations
clockDifference
	"Return a Duration expressing the difference between the remote and local clocks"
	
	| now |
	now := self now.
	^ self remoteClock - now