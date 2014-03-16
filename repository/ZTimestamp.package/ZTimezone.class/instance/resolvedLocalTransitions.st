accessing
resolvedLocalTransitions
	^ self localTransitions
		with: self subzonesIndex
		collect: [ :transition :subzone | (ZTimestamp fromUnixTime: transition) -> subzone ]