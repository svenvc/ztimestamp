instance creation
id: id
	"Return the timezone identified by id, either from cache or loading it if necessary"
	
	id = #GMT ifTrue: [ ^ self gmt ].
	^ self timezones
		at: id
		ifAbsentPut: [ self readTimezoneWithId: id ]