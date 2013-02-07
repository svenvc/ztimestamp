parsers
parseWeekdayNameAbbreviatedLowercasedFrom: stream
	| abbreviation fullName target |
	abbreviation := stream next: 3.
	target := abbreviation asLowercase capitalized.
	fullName := self weekdayNames detect: [ :each | 
		self string: each contains: target startingAt: 1 ].
	self assert: (fullName copyFrom: 1 to: 3) asLowercase = abbreviation.
	^ #weekday -> (self weekdayNames indexOf: fullName)