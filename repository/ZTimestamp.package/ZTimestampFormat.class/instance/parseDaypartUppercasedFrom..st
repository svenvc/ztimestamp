parsers
parseDaypartUppercasedFrom: stream
	| part |
	part := stream next: 2.
	self assert: (#(#AM #PM) includes: part).
	^ #daypart -> part asLowercase asSymbol