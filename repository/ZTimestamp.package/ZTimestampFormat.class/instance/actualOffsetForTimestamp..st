private
actualOffsetForTimestamp: timestamp
	^ self timezone value
		ifNil: [ timestamp offset ]
		ifNotNil: [ :actualTimezone | actualTimezone offsetForTimestamp: timestamp ]