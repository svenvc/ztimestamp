testing
testDaylightSavingTimeTransition
	"Daylight Saving Time (DST) creates a discontinuity 
	in the local wall time when the transition occurs.
	For timezone Europe/Brussels, on March 30, 2014, at 01:00 GMT,
	the offset goes from 1 hour (CET) to 2 hours (CEST), which means that
	the local wall time jumps from 02:00 to 03:00 on that day.
	Local time within that interval is ill defined."

	| timezone |
	timezone := ZTimezone id: 'Europe/Brussels'.
	"1 second before the transition"
	self
		assert: (timezone gmtToLocal: (ZTimestamp fromString: '2014-03-30T00:59:59Z'))
		equals: (ZTimestamp fromString: '2014-03-30T01:59:59Z').
	"a second later the transition occurs, jumping 1 hour forward"
	self
		assert: (timezone gmtToLocal: (ZTimestamp fromString: '2014-03-30T01:00:00Z'))
		equals: (ZTimestamp fromString: '2014-03-30T03:00:00Z').
	"reverse conversion just before the transition"
	self
		assert: (timezone localToGmt: (ZTimestamp fromString: '2014-03-30T01:59:59Z'))
		equals: (ZTimestamp fromString: '2014-03-30T00:59:59Z').	
	"reverse conversion a second later, after jumping 1 hour forward in local wall time"
	self
		assert: (timezone localToGmt: (ZTimestamp fromString: '2014-03-30T03:00:00Z'))
		equals: (ZTimestamp fromString: '2014-03-30T01:00:00Z').	
	"for an ill defined local wall time inside the jump, the offset is still 1 hour"
	self
		assert: (timezone localToGmt: (ZTimestamp fromString: '2014-03-30T02:30:00Z'))
		equals: (ZTimestamp fromString: '2014-03-30T01:30:00Z').
	"but converting that GMT timestamp gives a different local wall time"
	self
		assert: (timezone gmtToLocal: (ZTimestamp fromString: '2014-03-30T01:30:00Z'))
		equals: (ZTimestamp fromString: '2014-03-30T03:30:00Z').

