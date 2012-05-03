asserting
assertTimestamp: timestamp equalsTimestamp: reference 
	self assert: reference julianDayNumber = timestamp julianDayNumber.
	self assert: reference secondsSinceMidnight = timestamp secondsSinceMidnight.
	self assert: reference year = timestamp year.
	self assert: reference month = timestamp month.
	self assert: reference dayOfMonth = timestamp dayOfMonth.
	self assert: reference hour = timestamp hour.
	self assert: reference minute = timestamp minute.
	self assert: reference second = timestamp second