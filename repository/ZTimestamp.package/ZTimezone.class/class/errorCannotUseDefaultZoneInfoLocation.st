private
errorCannotUseDefaultZoneInfoLocation
	^ self
		error:
			'Cannot default to standard /usr/share/zoneinfo/ location,' , 
			'please specify a location using #zoneInfoLocation:'