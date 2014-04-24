parsers
parseTimeZoneAbbreviatedLongFrom: stream
	| offset |
	offset := String streamContents: [ :out |
		[ stream atEnd not and: [ 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' includes: stream peek ] ]
			whileTrue: [ out nextPut: stream next ] ].
	^ #offset -> (self offsetForTimeZoneAbbreviation: offset)