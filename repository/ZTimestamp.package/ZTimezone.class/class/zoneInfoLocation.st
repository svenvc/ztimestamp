acccessing
zoneInfoLocation
	"Return the zone info database location currently in use"
	
	^ ZoneInfoLocation ifNil: [ ZoneInfoLocation := self defaultZoneInfoLocation ]