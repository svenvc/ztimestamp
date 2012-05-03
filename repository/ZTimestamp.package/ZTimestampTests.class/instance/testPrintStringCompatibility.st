testing
testPrintStringCompatibility
	| dateTime timestamp |
	dateTime := DateAndTime now truncated printString.
	timestamp := (ZTimestamp fromString: dateTime) localPrintString.
	self assert: dateTime equals: timestamp