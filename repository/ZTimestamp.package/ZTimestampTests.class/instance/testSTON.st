testing
testSTON
	Smalltalk at: #STON ifPresent: [ :ston | 
		| now |
		now := ZTimestamp now.
		self 
			assert: (ston fromString: (ston toString: now)) 
			equals: now ]