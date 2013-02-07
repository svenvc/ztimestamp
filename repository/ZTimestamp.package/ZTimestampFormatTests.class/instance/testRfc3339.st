testing
testRfc3339
	| now |
	now := ZTimestamp now.
	self 
		assert: (ZTimestampFormat rfc3339 format: now)
		equals: now printString.
	self
		assert: (ZTimestampFormat rfc3339 parse: now printString)
		equals: now.
	self 
		assert: (ZTimestampFormat rfc3339 format: ZTimestampFormat reference12)
		equals: ZTimestampFormat reference12 printString.
	self
		assert: (ZTimestampFormat rfc3339 parse: ZTimestampFormat reference12 printString)
		equals: ZTimestampFormat reference12.
	self 
		assert: (ZTimestampFormat rfc3339 format: ZTimestampFormat reference24)
		equals: ZTimestampFormat reference24 printString.
	self
		assert: (ZTimestampFormat rfc3339 parse: ZTimestampFormat reference24 printString)
		equals: ZTimestampFormat reference24.