testing
testStringAsZTimestamp
	self assert: '1969-07-20T20:17:40Z' asZTimestamp equals: self lunarLanding. 
	self assert: '1969/07/20 20:17:40+00:00' asZTimestamp equals: self lunarLanding. 
	self assert: '19690720T201740Z' asZTimestamp equals: self lunarLanding. 
	self assert: '19690720' asZTimestamp equals: self lunarLanding asBeginOfDay 