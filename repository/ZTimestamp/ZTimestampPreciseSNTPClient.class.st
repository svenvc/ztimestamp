"
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

Normally this difference should be just just fractions of a second. If not, make sure your computer's clock itself is properly synchronized.
"
Class {
	#name : #ZTimestampPreciseSNTPClient,
	#superclass : #ZTimestampSNTPClient,
	#category : #ZTimestamp
}

{ #category : #accessing }
ZTimestampPreciseSNTPClient >> now [
	^ DateAndTime now asUTC
]

{ #category : #accessing }
ZTimestampPreciseSNTPClient >> ntpEpoch [
	^ DateAndTime year: 1900 month: 1 day: 1 hour: 0 minute: 0 second: 0 offset: Duration zero
]

{ #category : #private }
ZTimestampPreciseSNTPClient >> timestampFromSeconds: seconds fraction: fraction [
	^ self ntpEpoch + seconds seconds + (fraction * (10 raisedToInteger: 9)) nanoSeconds 
]
