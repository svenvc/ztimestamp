acccessing
zoneTab
	"Return the zone tab, a list of pairs, timezone identifier and country code"
	
	^ ZoneTab ifNil: [ ZoneTab := self readZoneTab ]