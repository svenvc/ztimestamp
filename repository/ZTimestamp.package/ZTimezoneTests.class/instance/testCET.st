testing
testCET

	"Test that CET timezone is found"
	
	self shouldnt: [ ZTimezone id: 'CET' ] raise: Error  