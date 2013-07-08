operations
sync
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