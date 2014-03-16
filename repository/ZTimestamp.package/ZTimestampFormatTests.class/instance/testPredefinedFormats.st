testing
testPredefinedFormats
	| reference now |
	reference := ZTimestampFormat reference24.
	now := DateAndTime now truncated.
	#(ansiC verbose kitchen rfc3339 rfc822 rfc850 unixDate) 
		do: [ :each | | format target |
			format := ZTimestampFormat perform: each.
			target := format specification copy replaceAll: $_ with: $ . 
			self assert: (format format: reference) equals: target ].
	#(verbose rfc3339 iso isoTZ) 
		do: [ :each | | format |
			(format := ZTimestampFormat perform: each)
				createDateAndTime.
			self assert: (format parse: (format format: now)) equals: now ].
	now := ZTimestamp now.
	#(isoCompact) 
		do: [ :each | | format|
			format := ZTimestampFormat perform: each.
			self assert: (format parse: (format format: now)) equals: now ].
	