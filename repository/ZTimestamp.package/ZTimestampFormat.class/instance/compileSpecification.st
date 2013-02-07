private
compileSpecification
	| offset elements |
	elements := Array streamContents: [ :stream |
		offset := 1.
		[ offset <= specification size ] whileTrue: [ 
			(self nextFormatKeyStartingAt: offset)
				ifNotNil: [ :formatKey |
					stream nextPut: (self class formats at: formatKey).
					offset := offset + formatKey size ]
				ifNil: [ 
					stream nextPut: (specification at: offset).
					offset := offset + 1 ] ] ].
	formatter := elements collect: [ :each | 
			each isCharacter ifTrue: [ each ] ifFalse: [ (#format:, each, #On:) asSymbol ] ].
	parser := elements collect: [ :each | 
			each isCharacter ifTrue: [ each ] ifFalse: [ (#parse, each capitalized, #From:) asSymbol ] ] 