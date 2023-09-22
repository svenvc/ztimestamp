Extension { #name : #ZTimestamp }

{ #category : #'*ZTimestamp-GT' }
ZTimestamp >> gtViewDetailsIn: composite [
	<gtView>
	^ composite columnedList
		title: 'Details';
		items: [ {('iso' -> self printString).
			('year' -> self year).
			('month' -> self monthIndex).
			('month name' -> self monthName).
			('day of month' -> self dayOfMonth).
			('day of week' -> self dayOfWeekName).
			('day of year' -> self dayOfYear).
			('hours' -> self hours).
			('minutes' -> self minutes).
			('seconds' -> self seconds).
			('nanoseconds' -> self nanoSecond).
			('offset' -> self offset).
			('date' -> self asDate).
			('time' -> self asTime).
			('unix time' -> self asUnixTime).
			('julian day number' -> self julianDayNumber).
			('nanoseconds since midnight' -> self nanosecondsSinceMidnight) } ];
		column: 'Key' text: #key;
		column: 'Value' text: #value;
		send: #value
]
