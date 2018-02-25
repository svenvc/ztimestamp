instance creation
localtime
	"Return the special localtime timezone, 
	containing the current local timezone offset as one fixed transition"
	
	^ self timezones at: #localtime ifAbsentPut: [ self createLocaltime ]