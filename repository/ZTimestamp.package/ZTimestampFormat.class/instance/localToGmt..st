private
localToGmt: timestamp
	^ self timezone value 
		ifNil: [ timestamp ] 
		ifNotNil: [ :actualTimezone | actualTimezone localToGmt: timestamp ]