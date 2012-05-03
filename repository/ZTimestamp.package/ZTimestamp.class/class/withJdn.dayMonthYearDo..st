accessing
withJdn: jdn dayMonthYearDo: block
	"Return the value of executing block with the Gregorian Calender day, month and year as arguments,
	as computed from my Julian Day Number, jdn.
	See http://en.wikipedia.org/wiki/Julian_date#Gregorian_calendar_from_Julian_day_number"
	
	| j g dg c dc b db a da y m d |
	j := jdn + 32044.
	g := j // 146097.
	dg := j \\ 146097.
	c := ((dg // 36524) + 1) * 3 // 4.
	dc := dg - (c * 36524).
	b := dc // 1461.
	db := dc \\ 1461.
	a := ((db // 365) + 1) * 3 // 4.
	da := db - (a * 365).
	y := (g * 400) + (c * 100) + (b * 4) + a.
	m := ((((da * 5) + 308)) // 153) - 2.
	d := da - ((m + 4) * 153 // 5) + 122.
	^ block
		value: d + 1
		value: ((m + 2) \\ 12) + 1
		value: (y - 4800 + ((m * 2) // 12)) 