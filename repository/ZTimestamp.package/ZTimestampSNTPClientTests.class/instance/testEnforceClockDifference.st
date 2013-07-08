testing
testEnforceClockDifference
	self clientClass new 
		enforceClockDifference: 5 seconds 
		ifFail: [ :difference | 
			self fail: ('Clock difference too large ({1} > 5s)' format: { difference } ) ]