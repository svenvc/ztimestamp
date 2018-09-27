instance creation
fromFile: file
	"Parse the binary compiled tzfile at file and return a timezone. Do not cache."
	"self fromFile: '/usr/share/zoneinfo/Europe/Brussels'."

	| fileReference |
	fileReference := file asFileReference.
	^ (fileReference respondsTo: #binaryReadStreamDo:)
		ifTrue: [ 
			fileReference binaryReadStreamDo: [ :in | 
				self fromStream: in ] ] 
		ifFalse: [ 
			fileReference readStreamDo: [ :in |
				in binary. 
				self fromStream: in ] ]