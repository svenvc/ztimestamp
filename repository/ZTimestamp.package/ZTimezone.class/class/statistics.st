utilties
statistics
	"Give an indication of the amount of data I currently cache"
	"self statistics."
	
	^ { 
			#totalTimezones -> self timezones size.
			#totalTransitions -> (self timezones sum: [ :each | each transitions size ]).
			#totalSubzones -> (self timezones sum: [ :each | each subzones size ])
		} asDictionary 