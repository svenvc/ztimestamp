accessing
resolvedTransitions
	^ self transitions
		with: self subzonesIndex
		collect: [ :transition :subzone | (ZTimestamp fromUnixTime: transition) -> subzone ]