accessing
timezone: anObject
	"Set the optional timezone that I should use to convert UTC/GMT/Zulu timestamps 
	into local time representations and vice versa if none is specified.
	The timezone object will be sent #value before use.
	When the value is nil, no conversions will be done.
	The returned value will be sent #offsetForTimestamp: when used."
	
	timezone := anObject