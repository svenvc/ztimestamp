acccessing
locationForId: id
	"Return a FileReference to the file containing the compiled binary data 
	for the timezone identified by id, with $/ indicating directory levels"
	
	| location |
	location := self zoneInfoLocation.
	($/ split: id) do: [ :each |
		location := location / each ].
	^ location