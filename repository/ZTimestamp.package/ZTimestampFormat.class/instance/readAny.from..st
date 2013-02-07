private
readAny: strings from: stream
	"Read any of the sorted collection strings from stream, or nil"
	
	| candidate matchCount |
	candidate := 1.
	matchCount := 0.
	[
		(strings at: candidate) size = matchCount 
			ifTrue: [ ^ strings at: candidate ].
		(stream atEnd or: [ candidate > strings size ])
			ifTrue: [ ^ nil ].
		(((strings at: candidate) at: matchCount + 1) = stream peek)
			ifTrue: [
				stream next.
				matchCount := matchCount + 1 ]
			ifFalse: [
				candidate := candidate + 1.
				(candidate <= strings size
					and: [ (1 to: matchCount) allSatisfy: [ :each | 
								((strings at: candidate - 1) at: each) = ((strings at: candidate) at: each) ] ])
					ifFalse: [ ^ nil ] ]
	] repeat