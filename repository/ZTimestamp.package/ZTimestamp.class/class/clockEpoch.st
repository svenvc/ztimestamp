private
clockEpoch
	"Return the epoch of the clock that we use as an instance (cached), see #now
	This is expressed in UTC regardless of #clockSeconds, see #clockTimezoneOffset"
	
	^ ClockEpoch ifNil: [
		ClockEpoch := self year: 1901 month: 1 day: 1 ]