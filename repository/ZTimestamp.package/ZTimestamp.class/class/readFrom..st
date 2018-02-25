instance creation
readFrom: stream
	"Parse a ISO 8601 representation from stream, in the format
	year[-]month[-]day[T]hour[:]minute[:]second[[+|-]hh[:][mm]]
	where the whole part after T as well as the TZ offset is optional.
	TZ offset can be Z, all separators can be any non digit.
	Supports reduced accuracy from least to most significant in time."

	| negative year month day hour minute second offset |
	negative := stream peekFor: $-.
	year := self readInteger: 4 from: stream.
	negative ifTrue: [ year := year negated ].
	self readOptionalSeparatorExpecting: '0123456789' from: stream.
	month := self readInteger: 2 from: stream.
	self readOptionalSeparatorExpecting: '0123456789' from: stream.
	day := self readInteger: 2 from: stream.
	hour := minute := second := offset := 0.
	(self readOptionalSeparatorExpecting: '0123456789' from: stream)
		ifTrue: [
			hour := self readInteger: 2 from: stream.
			(self readOptionalSeparatorExpecting: '0123456789' from: stream)
				ifTrue: [
					minute := self readInteger: 2 from: stream.
					(self readOptionalSeparatorExpecting: '0123456789' from: stream)
						ifTrue: [ second := self readInteger: 2 from: stream ] ]. 
			offset := self readTimezoneOffsetFrom: stream ].
	^ self 
		year: year
		month: month
		day: day
		hour: hour
		minute: minute
		second: second
		offset: (offset = 0 ifTrue: [ 0 ] ifFalse: [ offset seconds ])