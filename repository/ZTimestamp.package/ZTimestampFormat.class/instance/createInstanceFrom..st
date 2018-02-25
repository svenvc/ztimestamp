private
createInstanceFrom: elements
	elements 
		at: #daypart 
		ifPresent: [ :daypart | | hour |
			hour :=  elements at: #hour.
			(daypart = #pm and: [ hour < 12 ])
				ifTrue: [ elements at: #hour put: hour + 12 ].
			(daypart = #am and: [ hour = 12 ])
				ifTrue: [ elements at: #hour put: 0 ] ].
	^ self constructor value: elements