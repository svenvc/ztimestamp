instance creation
readFrom: stream
	"Parse a ISO 8601 representation from stream, in the format
	year[-]month[-]day[T]hour[:]minute[:]second[[+|-]hh[:]mm]
	where the whole part after T as well as the TZ offset is optional.
	TZ offset can be Z, all separators can be any non digit"

	| year month day hour minute second timestamp offset |
	year := self readInteger: 4 from: stream.
	self readOptionalSeparatorFrom: stream.
	month := self readInteger: 2 from: stream.
	self readOptionalSeparatorFrom: stream.
	day := self readInteger: 2 from: stream.
	(self readOptionalSeparatorFrom: stream)
		ifNotNil: [
			hour := self readInteger: 2 from: stream.
			self readOptionalSeparatorFrom: stream.
			minute := self readInteger: 2 from: stream.
			self readOptionalSeparatorFrom: stream.
			second := self readInteger: 2 from: stream.
			offset := self readTimezoneOffsetFrom: stream ]
		ifNil: [
			hour := minute := second := offset := 0 ].
	timestamp := self 
		year: year
		month: month
		day: day
		hour: hour
		minute: minute
		second: second.
	^ offset = 0
		ifTrue: [ timestamp ]
		ifFalse: [ timestamp - offset seconds ]