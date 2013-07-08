private
interpretResult: bytes t0: t0 t1: t1
	| t2 t3 |
	t2 := self timestampAt: self receiveOffset in: bytes.
	t3 := self timestampAt: self transmitOffset in: bytes.
	^ Dictionary newFromPairs: { 
		#timestamp. t3.
		#roundtripDelay. (t3 - t0) - (t2 - t1).
		#localClockOffset. ((t1 - t0) + (t2 - t3)) / 2.
		#datagram. bytes }