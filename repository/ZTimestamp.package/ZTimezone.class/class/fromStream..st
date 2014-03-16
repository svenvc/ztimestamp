instance creation
fromStream: in
	"Parse binary tzfile format data from in and return a timezone"
	
	| timezone header rawSubzones abbreviations |
	timezone := self new.
	self checkMagicFrom: in.
	header := self readHeaderFrom: in.
	timezone transitions: (self 
		count: (header at: #transitionCount) 
		do: [ :out | out nextPut: in int32 ]).
	timezone subzonesIndex: (in next: (header at: #transitionCount)).
	rawSubzones := self
		count: (header at: #typeCount)
		do: [ :out | out nextPut: { in int32. in next. in next } ].
	timezone leapSeconds: (self
		count: (header at: #leapCount)
		do: [ :out | out nextPut: { in uint32. in uint32 } ]).
	abbreviations := (in next: (header at: #abbreviationCount)) asString. 
	timezone resolveSubzones: rawSubzones abbreviations: abbreviations.
	timezone resolveStandardIndicators: (in next: (header at: #wallCount)).
	timezone resolveUtcIndicators: (in next: (header at: #utcCount)).
	^ timezone