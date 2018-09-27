"
I am ZTimestampSNTPClientTests, a test suite for ZTimestampSNTPClient.
"
Class {
	#name : #ZTimestampSNTPClientTests,
	#superclass : #TestCase,
	#category : 'ZTimestamp'
}

{ #category : #accessing }
ZTimestampSNTPClientTests >> clientClass [
	^ ZTimestampSNTPClient 
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
	self assert: differences average <= 2
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
	self assert: differences average <= 2
]

{ #category : #testing }
ZTimestampSNTPClientTests >> testEnforceClockDifference [
	self clientClass new 
		enforceClockDifference: 5 seconds 
		ifFail: [ :difference | 
			self fail: ('Clock difference too large ({1} > 5s)' format: { difference } ) ]
]

{ #category : #testing }
ZTimestampSNTPClientTests >> testLocalClockOffset [
	| client offset |
	client := self clientClass new.
	offset := client localClockOffset.
	client close.
	self assert: offset <= 2 seconds
]

{ #category : #testing }
ZTimestampSNTPClientTests >> testRoundtripDelay [
	| client delay |
	client := self clientClass new.
	delay := client roundtripDelay.
	client close.
	self assert: delay <= 2 seconds
]
