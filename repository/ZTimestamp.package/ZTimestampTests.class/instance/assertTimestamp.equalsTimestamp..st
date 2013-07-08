asserting
assertTimestamp: timestamp equalsTimestamp: reference 
	self assert: reference julianDayNumber = timestamp julianDayNumber.
	"Let's try to stay compatible between Pharo 3.0 and 2.0, it is just for testing anyway"
	[ self assert: reference secondsSinceMidnight = timestamp secondsSinceMidnight ]
		on: Deprecation do: [ :exception | exception return ].
	self assert: reference year = timestamp year.
	self assert: reference month = timestamp month.
	self assert: reference dayOfMonth = timestamp dayOfMonth.
	self assert: reference hour = timestamp hour.
	self assert: reference minute = timestamp minute.
	self assert: reference second = timestamp second