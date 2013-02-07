parsers
parseMonthNameAbbreviatedCapitalizedFrom: stream
	| abbreviation fullName target |
	abbreviation := stream next: 3.
	target := abbreviation asLowercase capitalized.
	fullName := self monthNames detect: [ :each | 
		self string: each contains: target startingAt: 1 ].
	self assert: (fullName copyFrom: 1 to: 3) capitalized = abbreviation.
	^ #month -> (self monthNames indexOf: fullName)