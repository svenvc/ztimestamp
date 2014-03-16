instance creation
year: year month: month day: day hour: hour minute: minute second: second offset: offset
	"Create and return a new ZTimestamp for the Gregorian calendar date described by year, month and date
	and the Civil time of day on that date described by hour, minute and second.
	If offset is non zero, the result is shifted accordingly."

	| timestamp |
	(timestamp := self new)
		jdn: (self jdnFromYear: year month: month day: day)
		secs: (hour * 3600) + (minute * 60) + second.
	offset isZero 
		ifFalse: [ timestamp := timestamp - offset ].
	^ timestamp 