private
createLocaltime
	^ self new
		id: #localtime;
		transitions: #();
		subzonesIndex: #[ 0 ];
		subzones: { ZSubTimezone localtime };
		resolveSubzonesIndex;
		yourself