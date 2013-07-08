private
receiveDatagram: bytes
	50 timesRepeat: [ 
		((socket receiveUDPDataInto: bytes) at: 1) > 0
			ifTrue: [ ^ self ].
		(Delay forMilliseconds: 5) wait ]