formatters
format: object hour12TwoDigitsOn: stream
	| hour |
	hour := object hour.
	(hour > 12
		ifTrue: [ hour - 12 ]
		ifFalse: [ 
			hour < 1
				ifTrue: [ 12 ]
				ifFalse: [ hour ] ]) printOn: stream base: 10 length: 2 padded: true