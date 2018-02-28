acccessing
zoneInfoLocation: directory
	"Set the location of the zone info database to directory"
	
	ZoneInfoLocation := directory ifNotNil: [ :dir | dir asFileReference ]