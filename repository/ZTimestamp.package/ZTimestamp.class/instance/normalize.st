initialize-release
normalize
	"Normalize the receiver such that 0 <= secs < 86400"
	 
	(secs between: 0 and: 86399)
		ifFalse: [
			jdn := jdn + (secs // 86400).
			secs := secs \\ 86400 ]