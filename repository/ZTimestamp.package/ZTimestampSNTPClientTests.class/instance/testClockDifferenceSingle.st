testing
testClockDifferenceSingle
	| differences client |
	client := self clientClass new.
	differences := (1 to: 10) collect: [ :each |
		| difference |
		difference := client clockDifference.
		difference seconds ].
	client close.
	self assert: differences average <= 2