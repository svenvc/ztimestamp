testing
testTimezoneFormatting
	| timestamp formatter |
	timestamp := ZTimestamp year: 2012 month: 4 day: 20 hour: 15 minute: 50 second: 10.
	formatter := [ :format :timezone| 
		String streamContents: [ :stream | 
			timestamp printOn: stream format: format timezone: timezone] ].
	self assert: (formatter value: #($- $T $: nil) value: 2 hours) = '2012-04-20T17:50:10+02:00'.
	self assert: (formatter value: #($- $T $: nil) value: -2 hours) = '2012-04-20T13:50:10-02:00'.
	self assert: (formatter value: #(nil $T nil nil) value: 1 hours) = '20120420T165010+0100'.
	self assert: (formatter value: #(nil $T nil nil) value: -1 hours) = '20120420T145010-0100'.
