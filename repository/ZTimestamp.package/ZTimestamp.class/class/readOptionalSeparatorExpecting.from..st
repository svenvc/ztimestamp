private
readOptionalSeparatorExpecting: nonSeparators from: stream
	"Read an optional separator (all but nonSeparators) from stream.
	Return true when a nonSeparator is peeked, false otherwise.
	Note that EOF returns false."

	(nonSeparators includes: stream peek)
		ifFalse: [ stream next notNil ].
	^ nonSeparators includes: stream peek