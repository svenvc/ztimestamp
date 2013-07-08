testing
testClockDifferenceMulti
	| differences |
	differences := (1 to: 10) collect: [ :each |
		| client difference |
		client := self clientClass new.
		difference := client clockDifference.
		client close.
		difference seconds ].
	self assert: differences average <= 2