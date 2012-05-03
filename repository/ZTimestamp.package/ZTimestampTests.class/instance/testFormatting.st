testing
testFormatting
	| timestamp formatter |
	timestamp := ZTimestamp year: 2012 month: 4 day: 20 hour: 15 minute: 50 second: 10.
	formatter := [ :format | 
		String streamContents: [ :stream | 
			timestamp printOn: stream format: format ] ].
	self assert: (formatter value: #($- $T $: $Z)) = '2012-04-20T15:50:10Z'.
	self assert: (formatter value: #(nil $T nil nil)) = '20120420T155010'.
	self assert: (formatter value: #($/ $| $: $Z)) = '2012/04/20|15:50:10Z'.
	self assert: (formatter value: #($- $T $: nil)) = '2012-04-20T15:50:10'.