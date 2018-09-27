private
dateError: message
	(Smalltalk at: #DateError ifAbsent: [ Error ]) signal: message