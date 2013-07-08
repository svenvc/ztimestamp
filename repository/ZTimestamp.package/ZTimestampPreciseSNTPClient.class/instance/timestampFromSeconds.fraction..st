private
timestampFromSeconds: seconds fraction: fraction
	^ self ntpEpoch + seconds seconds + (fraction * (10 raisedToInteger: 9)) nanoSeconds 