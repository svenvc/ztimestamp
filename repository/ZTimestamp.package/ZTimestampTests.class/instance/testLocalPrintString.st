testing
testLocalPrintString
	| timestamp reference |
	timestamp := ZTimestamp now localPrintString.
	reference := DateAndTime now truncated printString.
	self assert: timestamp = reference