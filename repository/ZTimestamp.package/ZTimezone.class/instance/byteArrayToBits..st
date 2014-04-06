private
byteArrayToBits: byteArray
	| bits |
	bits := 0.
	byteArray withIndexDo: [ :each :index |
		bits := bits bitAt: index put: each ].
	^ bits