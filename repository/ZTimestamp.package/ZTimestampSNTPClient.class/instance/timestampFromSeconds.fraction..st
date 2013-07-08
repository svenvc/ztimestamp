private
timestampFromSeconds: seconds fraction: fraction
	^ self ntpEpoch + seconds seconds + fraction rounded