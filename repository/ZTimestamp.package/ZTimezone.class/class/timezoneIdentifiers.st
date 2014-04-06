acccessing
timezoneIdentifiers
	"Return the list of supported timezone identifiers.
	#GMT is a special case that is also supported, but it is not in the zonetab."
	
	^ self zoneTab collect: #first