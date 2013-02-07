initialize-release
createDate
	self constructor: [ :elements | 
		Date 
			year: (elements at: #year ifAbsent: [ 0 ]) 
			month: (elements at: #month ifAbsent: [ 0 ])  
			day: (elements at: #day ifAbsent: [ 0 ]) ]