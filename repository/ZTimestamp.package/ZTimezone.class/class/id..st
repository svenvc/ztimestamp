instance creation
id: id
	"Return the timezone identified by id, either from cache or loading it if necessary.
	See #timezoneIdentifiers for the list of available identifiers. id is case sensitive."
	
	(self gmtAliases includes: id) 
		ifTrue: [ ^ self gmt ].
	(self localtimeAliases includes: id)
		ifTrue: [ ^ self localtime ].
	(self centralEuropeanAliases includes: id) 
		ifTrue: [ ^ self defaultZoneCET ] .

	^ self timezones
		at: id
		ifAbsentPut: [ self readTimezoneWithId: id ]