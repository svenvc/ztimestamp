parsers
parseDaypartLowercasedFrom: stream
	| part |
	part := stream next: 2.
	self assert: (#(#am #pm) includes: part).
	^ #daypart -> part asSymbol