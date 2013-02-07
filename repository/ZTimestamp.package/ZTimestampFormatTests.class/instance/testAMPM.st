testing
testAMPM
	| times format12 format24 |
	times := #( 
		('12:00AM' '00:00') ('12:01AM' '00:01') ('12:59AM' '00:59') ('01:00AM' '01:00') ('11:00AM' '11:00') ('11:59AM' '11:59')
		('12:00PM' '12:00') ('12:01PM' '12:01') ('12:59PM' '12:59')('01:00PM' '13:00') ('11:00PM' '23:00') ('11:59PM' '23:59') ).
	format12 := ZTimestampFormat fromString: '04:05PM'.
	format24 := ZTimestampFormat fromString: '16:05'.
	times do: [ :each |
		self assert: (format12 parse: each first) equals: (format24 parse: each second).
		self assert: (format12 format: (format12 parse: each first)) equals: each first.
		self assert: (format24 format: (format24 parse: each second)) equals: each second ]