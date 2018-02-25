private
createGMT
	^ self new
		id: #GMT;
		transitions: #();
		subzonesIndex: #[ 0 ];
		subzones: { ZSubTimezone gmt };
		resolveSubzonesIndex;
		yourself