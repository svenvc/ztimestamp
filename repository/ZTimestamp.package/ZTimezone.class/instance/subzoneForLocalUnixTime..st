public
subzoneForLocalUnixTime: unixTime
	"Given unixTime, the number of seconds since 1970-01-01, 
	return the TSubTimezone containing more information,
	applicable to that point in time (interpreted in local wall time)."
	
	^ self localTransitions
		findBinaryIndex: [ :offset | unixTime - offset ]
		do: [ :index | self subzoneForTransitionAt: index ]
		ifNone: [ :lower :upper | 
			| index |
			index := lower ~= 0
				ifTrue: [ lower ]																
				ifFalse: [ upper ].
			self subzoneForTransitionAt: index ]