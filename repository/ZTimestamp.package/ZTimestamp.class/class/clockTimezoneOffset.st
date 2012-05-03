private
clockTimezoneOffset
	"Return the timezone offset of the clock that we use as an Integer seconds (cached), see #now"

	^ ClockTimezoneOffset ifNil: [
		ClockTimezoneOffset := DateAndTime localTimeZone offset asSeconds ]