private
offsetForTimeZoneAbbreviation: abbreviation
	"(TimeZone abbreviated: abbreviation) offset"

	self class abbreviatedTimeZones
		do: [ :each | 
			each first = abbreviation
				ifTrue: [ ^ each second hours ] ].
	self error: 'Cannot find time zone for abbreviation ' , abbreviation asString