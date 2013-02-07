initialize-release
createTime
	self constructor: [ :elements | 
		Time 
			hour: (elements at: #hour ifAbsent: [ 0 ]) 
			minute: (elements at: #minute ifAbsent: [ 0 ])  
			second: (elements at: #second ifAbsent: [ 0 ]) ]