testing
testParsingError
	self should: [ ZTimestamp fromString: '45451-09-06T11:01:07Z' ] raise: Error