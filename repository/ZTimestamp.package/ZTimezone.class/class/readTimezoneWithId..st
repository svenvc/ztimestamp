instance creation
readTimezoneWithId: id
	"Parse and load the timezone with id, do not cache"

	"self readTimezoneWithId: #'Europe/Brussels'."

	| location timezone |
	self zoneTab 
		detect: [ :each | each first = id ] 
		ifNone: [ ^ self error: 'Unknown Timezone ID: ' , id asString ].
	location := self locationForId: id.
	timezone := self fromFile: location.
	timezone id: id.
	^ timezone