private
resolveSubzonesIndex
	| resolvedSubzonesIndex |
	resolvedSubzonesIndex := Array new: subzonesIndex size.
	1 to: subzonesIndex size do: [ :each |
		| index |
		index := (subzonesIndex at: each) + 1.
		resolvedSubzonesIndex at: each put: (subzones at: index) ].
	subzonesIndex := resolvedSubzonesIndex 