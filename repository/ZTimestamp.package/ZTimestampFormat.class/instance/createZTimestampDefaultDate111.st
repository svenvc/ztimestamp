initialize-release
createZTimestampDefaultDate111
	"Configure me to create ZTimestamp instances when parsing where the default date is 1-1-1.
	This is a (not so useful) hack to ignore the date component (but keep it a legal value), mainly used for testing."

	self constructor: [ :elements | 
		| timestamp |
		timestamp := ZTimestamp 
			year: (elements at: #year ifAbsent: [ 1 ]) 
			month: (elements at: #month ifAbsent: [ 1 ])  
			day: (elements at: #day ifAbsent: [ 1 ])  
			hour: (elements at: #hour ifAbsent: [ 0 ]) 
			minute: (elements at: #minute ifAbsent: [ 0 ])  
			second: (elements at: #second ifAbsent: [ 0 ]) 
			offset: (elements at: #offset ifAbsent: [ 0 ]).
		(elements includesKey: #offset)
			ifTrue: [ timestamp ]
			ifFalse: [ self localToGmt: timestamp ] ]