I am ZTimestampSNTPClient, I can access an NTP server to retrieve an external time stamp.

I can be used to verify the current clock.

	ZTimestampSNTPClient new clockDifference.
	
	ZTimestampSNTPClient new
		enforceClockDifference: 2 seconds
		ifFail: [ :delta | 
			self inform: ('Clock difference {1} > 2s' format: { delta }) ];
		close.
		
	ZTimestampSNTPClient logClockDifferenceLargerThan: 1 second. 

Normally this difference should be just one or two seconds. If not, make sure your computer's clock itself is properly synchronized.

Note that following the design of ZTimestamp we work in second precision.

See 
	http://en.wikipedia.org/wiki/Network_Time_Protocol
	http://tools.ietf.org/html/rfc2030