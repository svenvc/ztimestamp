accessing
abbreviatedTimeZones
	"Map TimeZone abbreviations to their offsets"
	"Order matters for lookup by offset !"
	"Initially created then edited by hand using"
	"TimeZone timeZones collect: [ :each | { each abbreviation. each offset hours } ]"

	^ #(
		#('UTC' 0) 
		#('GMT' 0) 
		#('CET' 1)
		#('BST' 1) 
		#('SAST' 2) 
		#('PST' -8) 
		#('PDT' -7) 
		#('MST' -7) 
		#('MDT' -6) 
		#('CST' -6) 
		#('CDT' -5) 
		#('EST' -5) 
		#('EDT' -4))