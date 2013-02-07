private
string: string contains: subString startingAt: offset
	subString doWithIndex: [ :each :index |
		offset + index - 1 <= string size 
			ifFalse: [ ^ false ].
		(string at: offset + index - 1) = each
			ifFalse: [ ^ false ] ].
	^ true