*ztimestamp
asZTimestamp
	^ ZTimestamp new
		jdn: self julianDayNumber 
		secs: seconds - offset asSeconds