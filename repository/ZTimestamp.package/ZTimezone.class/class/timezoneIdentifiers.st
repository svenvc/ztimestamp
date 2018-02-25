acccessing
timezoneIdentifiers
	"Return the list of supported timezone identifiers.
	#gmtAliases and #localtimeAliases are special cases that are also supported, 
	but are not in the zonetab. Identifiers are case sensitive."
	
	^ self zoneTab collect: #first