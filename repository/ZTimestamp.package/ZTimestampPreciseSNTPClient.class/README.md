I am ZTimestampPreciseSNTPClient.
I am a ZTimestampSNTPClient.

I use DataAndTime with theoretical nanosecond precision.

I can be used to verify the current clock.

	ZTimestampPreciseSNTPClient new clockDifference.
	
	ZTimestampPreciseSNTPClient new
		enforceClockDifference: 2 seconds
		ifFail: [ :delta | 
			self inform: ('Clock difference {1} > 2s' format: { delta }) ];
		close. 
		
	ZTimestampPreciseSNTPClient logClockDifferenceLargerThan: 1 second.

Normally this difference should be just just fractions of a seconds. If not, make sure your computer's clock itself is properly synchronized.