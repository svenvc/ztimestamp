private
clockTimezoneOffset
	"Return the timezone offset of the clock that we use as an Integer seconds (cached), see #now.
	In a 3.0 image, which implements #primUTCMicrosecondsClock, Time>>#totalSeconds is UTC,
	where in 2.0 it is in local time."

	^ ClockTimezoneOffset
		ifNil: [ 
			ClockTimezoneOffset := (Time respondsTo: #primUTCMicrosecondsClock)
				ifTrue: [ 0 ]
				ifFalse: [ DateAndTime localTimeZone offset asSeconds ] ]