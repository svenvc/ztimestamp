private
readTimezoneOffsetFrom: stream
	"Read and return an optional timezone offset in the form of 
	[+|-]hh[separator]mm from stream as an Integer seconds.
	If there is no offset, just return 0"

	| sign hour minute |
	stream atEnd ifTrue: [ ^ 0 ].
	stream peek = $Z ifTrue: [ stream next. ^ 0 ].
	^ ('+-' includes: stream peek)
		ifTrue: [
			sign := stream next = $- ifTrue: [ -1 ] ifFalse: [ 1 ].
			hour := self readInteger: 2 from: stream.
			(self readOptionalSeparatorFrom: stream)
				ifNil: [ minute := 0 ]
				ifNotNil: [ minute := self readInteger: 2 from: stream ].
			sign * (hour * 3600) + (minute * 60) ]
		ifFalse: [ 0 ]
