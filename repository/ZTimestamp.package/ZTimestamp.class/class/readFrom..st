instance creation
readFrom: stream
	"Parse a ISO 8601 representation from stream, in the format
	year[-]month[-]day[T]hour[:]minute[:]second[[+|-]hh[:]mm]
	where the whole part after T as well as the TZ offset is optional.
	TZ offset can be Z, all separators can be any non digit"

	| year month day hour minute second offset |
	year := self readInteger: 4 from: stream.
	self readOptionalSeparatorFrom: stream.
	month := self readInteger: 2 from: stream.
	self readOptionalSeparatorFrom: stream.
	day := self readInteger: 2 from: stream.
	self readOptionalSeparatorFrom: stream.
	stream atEnd
		ifFalse: [
			hour := self readInteger: 2 from: stream.
			self readOptionalSeparatorFrom: stream.
			minute := self readInteger: 2 from: stream.
			self readOptionalSeparatorFrom: stream.
			second := self readInteger: 2 from: stream.
			offset := self readTimezoneOffsetFrom: stream ]
		ifTrue: [
			hour := minute := second := offset := 0 ].
	^ self 
		year: year
		month: month
		day: day
		hour: hour
		minute: minute
		second: second
		offset: (offset = 0 ifTrue: [ 0 ] ifFalse: [ offset seconds ])