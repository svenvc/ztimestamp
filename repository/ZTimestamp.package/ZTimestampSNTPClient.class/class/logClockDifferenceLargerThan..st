convenience
logClockDifferenceLargerThan: duration
	"self logClockDifferenceLargerThan: 1 second"
	
	self new
		enforceClockDifference: duration
		ifFail: [ :delta |
			self crLog:  ('Warning: clock difference {1} > {2}' format: { delta. duration }) ];
		close