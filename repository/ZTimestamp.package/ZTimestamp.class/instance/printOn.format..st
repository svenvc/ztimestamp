printing
printOn: stream format: format
	"Print the receiver on stream using format, following ISO 8601.
	Format defines 4 characters to use:
	#(dateSeparator dateTimeSeparator timeSeparator timeZoneSeparator)
	Each can be nil to skip that separator"
	
	self dayMonthYearDo: [ :day :month :year |
		year printOn: stream base: 10 length: 4 padded: true.
		(format at: 1) ifNotNil: [ :separator | stream nextPut: separator ].
		month printOn: stream base: 10 length: 2 padded: true.
		(format at: 1) ifNotNil: [ :separator | stream nextPut: separator ].
		day printOn: stream base: 10 length: 2 padded: true ].
	(format at: 2) ifNotNil: [ :separator | stream nextPut: separator ].
	self hour printOn: stream base: 10 length: 2 padded: true.
	(format at: 3) ifNotNil: [ :separator | stream nextPut: separator ].
	self minute printOn: stream base: 10 length: 2 padded: true.
	(format at: 3) ifNotNil: [ :separator | stream nextPut: separator ].
	self second printOn: stream base: 10 length: 2 padded: true.
	(format at: 4) ifNotNil: [ :separator | stream nextPut: separator ]