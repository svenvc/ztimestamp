accessing
zero
	"Return my zero instance, the point in time from which we start counting, see #epoch"

	^ Zero 
		ifNil: [ 
			Zero :=  self new
				jdn: 0 secs: 0 ]