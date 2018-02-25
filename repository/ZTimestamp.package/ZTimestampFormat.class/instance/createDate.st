initialize-release
createDate
	"Configure me to create Date instances when parsing"
	
	self constructor: [ :elements | 
		Date 
			year: (elements at: #year ifAbsent: [ 0 ]) 
			month: (elements at: #month ifAbsent: [ 0 ])  
			day: (elements at: #day ifAbsent: [ 0 ]) ]