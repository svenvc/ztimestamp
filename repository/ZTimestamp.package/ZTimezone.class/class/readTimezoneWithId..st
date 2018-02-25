instance creation
readTimezoneWithId: id
	"Parse and load the timezone with id, do not cache"

	"self readTimezoneWithId: #'Europe/Brussels'."

	| location timezone |
	location := self locationForId: id.
	timezone := self fromFile: location.
	timezone id: id.
	^ timezone