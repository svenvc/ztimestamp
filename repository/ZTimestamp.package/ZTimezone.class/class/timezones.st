acccessing
timezones
	"Return the currently cached timezones as a Dictionary"
	
	^ Timezones ifNil: [ Timezones := Dictionary new ]