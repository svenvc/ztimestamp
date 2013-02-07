class initialization
initialize
	Formats := Dictionary newFromPairs: self formatSpecifications.
	FormatKeys := Formats keys sorted: [ :x :y | x size >= y size ].
	