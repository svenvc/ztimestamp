utilties
readZoneTab
	"Parse and load the zone tab file, do not cache"
	"self readZoneTab"

	| file contents |
	file := self zoneInfoLocation / 'zone.tab'.
	contents := file readStreamDo: [ :in | in upToEnd ].
	^ (contents lines reject: [ :line | line first = $# ])
			collect: [ :lines | 
				| tokens |
				tokens := lines findTokens: Character separators.
				{ tokens third. tokens first } ]