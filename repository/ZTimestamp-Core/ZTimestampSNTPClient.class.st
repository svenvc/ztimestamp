"
I am ZTimestampSNTPClient, I can access an NTP server to retrieve an external timestamp.

I can be used to verify the current clock.

	ZTimestampSNTPClient new clockDifference.
	
	ZTimestampSNTPClient new
		enforceClockDifference: 2 seconds
		ifFail: [ :delta | 
			self inform: ('Clock difference {1} > 2s' format: { delta }) ];
		close.
		
	ZTimestampSNTPClient logClockDifferenceLargerThan: 1 second. 

Normally this difference should be just one or two seconds. 
If not, make sure your computer's clock itself is properly synchronized.

See 
	http://en.wikipedia.org/wiki/Network_Time_Protocol
	http://tools.ietf.org/html/rfc2030
"
Class {
	#name : #ZTimestampSNTPClient,
	#superclass : #Object,
	#instVars : [
		'socket',
		'serverAddress'
	],
	#category : #'ZTimestamp-Core'
}

{ #category : #convenience }
ZTimestampSNTPClient class >> logClockDifferenceLargerThan: duration [
	"self logClockDifferenceLargerThan: 1 second"
	
	self new
		enforceClockDifference: duration
		ifFail: [ :delta |
			self crTrace:  ('Warning: clock difference {1} > {2}' format: { delta. duration }) ];
		close
]

{ #category : #operations }
ZTimestampSNTPClient >> clockDifference [
	"Return a Duration expressing the difference between the remote and local clocks"
	
	| now |
	now := self now.
	^ self remoteClock - now
]

{ #category : #'initialize-release' }
ZTimestampSNTPClient >> close [
	socket close
]

{ #category : #operations }
ZTimestampSNTPClient >> enforceClockDifference: duration ifFail: block [ 
	"Check the difference between the remote and local clock,
	and execute block if it is larger than duration."
	
	| difference |
	difference := self clockDifference.
	difference > duration
		ifTrue: [ block cull: difference ]
]

{ #category : #private }
ZTimestampSNTPClient >> fractionalSecondsAt: offset in: bytes [
	^ (bytes copyFrom: offset to: offset + 3) asInteger / (2 raisedToInteger: 32)
]

{ #category : #private }
ZTimestampSNTPClient >> fullSecondsAt: offset in: bytes [
	^ (bytes copyFrom: offset to: offset + 3) asInteger
]

{ #category : #'initialize-release' }
ZTimestampSNTPClient >> initialize [
	socket := Socket newUDP.
	serverAddress := self ntpServerAddress 
]

{ #category : #private }
ZTimestampSNTPClient >> interpretResult: bytes t0: t0 t1: t1 [
	| t2 t3 |
	t2 := self timestampAt: self receiveOffset in: bytes.
	t3 := self timestampAt: self transmitOffset in: bytes.
	^ Dictionary newFromPairs: { 
		#timestamp. t3.
		#roundtripDelay. (t3 - t0) - (t2 - t1).
		#localClockOffset. ((t1 - t0) + (t2 - t3)) / 2.
		#datagram. bytes }
]

{ #category : #operations }
ZTimestampSNTPClient >> localClockOffset [
	"Return a Delay representing the local clock offiset 
	as computed using the NTP clock synchronization algorithm"

	| result |
	result := self sync.
	^ result at: #localClockOffset
]

{ #category : #accessing }
ZTimestampSNTPClient >> now [
	^ ZTimestamp now
]

{ #category : #accessing }
ZTimestampSNTPClient >> ntpEpoch [
	^ ZTimestamp year: 1900 month: 1 day: 1
]

{ #category : #accessing }
ZTimestampSNTPClient >> ntpPort [
	^ 123
]

{ #category : #accessing }
ZTimestampSNTPClient >> ntpServerAddress [
	^ NetNameResolver addressForName: self ntpServerHostname 
]

{ #category : #accessing }
ZTimestampSNTPClient >> ntpServerHostname [
	^ '0123' atRandom asString, '.pool.ntp.org'
]

{ #category : #constants }
ZTimestampSNTPClient >> originateOffset [
	^ 25
]

{ #category : #private }
ZTimestampSNTPClient >> receiveDatagram: bytes [
	50 timesRepeat: [ 
		((socket receiveUDPDataInto: bytes) at: 1) > 0
			ifTrue: [ ^ self ].
		(Delay forMilliseconds: 5) wait ]
]

{ #category : #constants }
ZTimestampSNTPClient >> receiveOffset [
	^ 33
]

{ #category : #constants }
ZTimestampSNTPClient >> referenceOffset [
	^ 17
]

{ #category : #operations }
ZTimestampSNTPClient >> remoteClock [
	"Return a timstamp with the value of the remote clock,
	more specifically the transmit timestamp of the NTP server"

	| result |
	result := self sync.
	^ result at: #timestamp
]

{ #category : #private }
ZTimestampSNTPClient >> requestDatagram: now [
	| bytes |
	bytes := ByteArray new: 48.
	bytes at: 1 put: 27.	"version 3, client mode"
	((now - self ntpEpoch) asSeconds asByteArrayOfSize: 4)
		withIndexDo: [ :byte :index | bytes at: self transmitOffset + index - 1 put: byte ].
	((now nanoSecond / (10 raisedToInteger: 9) * (2 raisedToInteger: 32)) rounded asByteArrayOfSize: 4) 
		withIndexDo: [ :byte :index | bytes at: self transmitOffset + 4 + index - 1 put: byte ].
	^ bytes
]

{ #category : #operations }
ZTimestampSNTPClient >> roundtripDelay [
	"Return the round trip delay
	as computed using the NTP clock synchronization algorithm"

	| result |
	result := self sync.
	^ result at: #roundtripDelay
]

{ #category : #operations }
ZTimestampSNTPClient >> sync [
	"Contact an NTP server and return a processed result,
	a Dictionary holding a #timestamp, #roundTripDelay, #localClockOffset and #datagram"

	| request result t0 t1 |
	t0 := self now.
	request := self requestDatagram: t0.
	result := ByteArray new: 48.
	socket sendUDPData: request toHost: serverAddress port: self ntpPort.
	self receiveDatagram: result.
	t1 := self now.
	^ self interpretResult: result t0: t0 t1: t1
]

{ #category : #private }
ZTimestampSNTPClient >> timestampAt: offset in: bytes [
	| seconds fractions |
	seconds := self fullSecondsAt: offset in: bytes.	
	fractions := self fractionalSecondsAt: offset + 4 in: bytes.
	^ self timestampFromSeconds: seconds fraction: fractions
]

{ #category : #private }
ZTimestampSNTPClient >> timestampFromSeconds: seconds fraction: fraction [
	^ self ntpEpoch + seconds seconds + (fraction * (10 raisedToInteger: 9)) nanoSeconds
]

{ #category : #constants }
ZTimestampSNTPClient >> transmitOffset [
	^ 41
]
