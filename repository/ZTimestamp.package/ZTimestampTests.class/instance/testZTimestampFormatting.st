testing
testZTimestampFormatting
	| timestamp |
	timestamp := self lunarLanding.
	self 
		assert: (timestamp format: '2001-02-03T16:05:06Z') 
		equals: '1969-07-20T20:17:40Z'.
	self 
		assert: (String streamContents: [ :out | timestamp format: '01/02/03 16:05:06' on: out ]) 
		equals: '69/07/20 20:17:40'.
