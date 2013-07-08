private
clockSeconds
	"Return the total seconds count of the clock that we use as an Integer since the #clockEpoch, 
	see #now. This can be in UTC or not, then it will be compensated using #clockTimezoneOffset"

	^ Time totalSeconds