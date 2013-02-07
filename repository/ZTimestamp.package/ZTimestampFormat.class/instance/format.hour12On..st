formatters
format: object hour12On: stream
	| hour |
	hour := object hour.
	(hour > 12
		ifTrue: [ hour - 12 ]
		ifFalse: [ 
			hour < 1
				ifTrue: [ 12 ]
				ifFalse: [ hour ] ]) printOn: stream