ston
stonOn: stonWriter
	"Use an ISO representation with all details"
	
	stonWriter writeObject: self listSingleton: 
		(String new: 20 streamContents: [ :stream |
			self printOn: stream ])