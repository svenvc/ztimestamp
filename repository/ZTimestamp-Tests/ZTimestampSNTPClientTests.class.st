"
I am ZTimestampSNTPClientTests, a test suite for ZTimestampSNTPClient.
"
Class {
	#name : #ZTimestampSNTPClientTests,
	#superclass : #TestCase,
	#category : #'ZTimestamp-Tests'
}

{ #category : #accessing }
ZTimestampSNTPClientTests >> clientClass [
	^ ZTimestampSNTPClient 
]

{ #category : #accessing }
ZTimestampSNTPClientTests >> delta [
	"Return the maximum number of seconds of delta that we allow.
	Note that under CI servers we need more time."
	
	^ 5
]

{ #category : #testing }
ZTimestampSNTPClientTests >> testClockDifferenceMulti [
	| differences |
	differences := (1 to: 10) collect: [ :each |
		| client difference |
		client := self clientClass new.
		difference := client clockDifference.
		client close.
		difference seconds ].
	self 
		assert: differences average <= self delta
		description: ('average differences too large, {1} > {2}s' format: { differences average. self delta })
]

{ #category : #testing }
ZTimestampSNTPClientTests >> testClockDifferenceSingle [
	| differences client |
	client := self clientClass new.
	differences := (1 to: 10) collect: [ :each |
		| difference |
		difference := client clockDifference.
		difference seconds ].
	client close.
	self 
		assert: differences average <= self delta
		description: ('average differences too large, {1} > {2}s' format: { differences average. self delta })
]

{ #category : #testing }
ZTimestampSNTPClientTests >> testEnforceClockDifference [
	self clientClass new 
		enforceClockDifference: self delta seconds 
		ifFail: [ :difference | 
			self fail: ('Clock difference too large ({1} > {2}s)' format: { difference. self delta } ) ]
]

{ #category : #testing }
ZTimestampSNTPClientTests >> testLocalClockOffset [
	| client offset |
	client := self clientClass new.
	offset := client localClockOffset.
	client close.
	self 
		assert: offset <= self delta seconds
		description: ('localClockOffset too large, {1} > {2}s' format: { offset. self delta })
]

{ #category : #testing }
ZTimestampSNTPClientTests >> testRoundtripDelay [
	| client delay |
	client := self clientClass new.
	delay := client roundtripDelay.
	client close.
	self 
		assert: delay <= self delta seconds 
		description: ('roundTripDelay too large, {1} > {2}s' format: { delay. self delta })
]
