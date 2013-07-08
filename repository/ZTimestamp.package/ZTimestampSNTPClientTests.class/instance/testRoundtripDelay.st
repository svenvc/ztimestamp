testing
testRoundtripDelay
	| client delay |
	client := self clientClass new.
	delay := client roundtripDelay.
	client close.
	self assert: delay <= 2 seconds