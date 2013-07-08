testing
testLocalClockOffset
	| client offset |
	client := self clientClass new.
	offset := client localClockOffset.
	client close.
	self assert: offset <= 2 seconds