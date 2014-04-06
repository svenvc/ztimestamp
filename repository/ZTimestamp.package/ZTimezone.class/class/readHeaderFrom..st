private
readHeaderFrom: in
	| header |
	header := Dictionary new.
	#(#utcCount #wallCount #leapCount #transitionCount #typeCount #abbreviationCount)
		do: [ :each | header at: each put: in uint32 ].
	^ header