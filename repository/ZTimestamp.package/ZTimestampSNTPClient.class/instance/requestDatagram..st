private
requestDatagram: now
	| bytes |
	bytes := ByteArray new: 48.
	bytes at: 1 put: 27.	"version 3, client mode"
	((now - self ntpEpoch) asSeconds asByteArrayOfSize: 4)
		withIndexDo: [ :byte :index | bytes at: self transmitOffset + index - 1 put: byte ].
	((now nanoSecond / (10 raisedToInteger: 9) * (2 raisedToInteger: 32)) rounded asByteArrayOfSize: 4) 
		withIndexDo: [ :byte :index | bytes at: self transmitOffset + 4 + index - 1 put: byte ].
	^ bytes