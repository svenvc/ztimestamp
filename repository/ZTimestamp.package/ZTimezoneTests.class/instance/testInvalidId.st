testing
testInvalidId

	self should: [ ZTimezone id: 'stuff' ] raise: FileDoesNotExist.
	self should: [ ZTimezone id: 'zone.tab' ] raise: AssertionFailure