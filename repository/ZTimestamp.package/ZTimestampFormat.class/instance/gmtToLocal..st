private
gmtToLocal: timestamp
	^ self timezone value
		ifNil: [ timestamp ]
		ifNotNil: [ :actualTimezone |actualTimezone gmtToLocal: timestamp ]