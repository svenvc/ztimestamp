private
resolveSubzones: rawSubzones abbreviations: abbreviations
	subzones := rawSubzones collect: [ :each | 
		| start stop |
		start := each third + 1.
		stop := abbreviations indexOf: Character null startingAt: start.
		ZSubTimezone 
			abbreviation: (abbreviations copyFrom: start to: stop - 1) 
			offset: each first seconds
			dst: each second = 1 ].
	self resolveSubzonesIndex 