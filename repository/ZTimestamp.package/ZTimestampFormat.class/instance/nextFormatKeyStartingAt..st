private
nextFormatKeyStartingAt: offset
	^ self class formatKeys
		detect: [ :each | self string: specification contains: each startingAt: offset ]
		ifNone: [ nil ]