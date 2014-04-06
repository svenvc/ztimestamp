private
abbreviationForTimeZoneOffset: offset
	"(TimeZone offset: offset) abbreviation"

	self class abbreviatedTimeZones
		do: [ :each | 
			each second = offset hours
				ifTrue: [ ^ each first ] ].
	self error: 'Cannot find time zone for offset ' , offset asString