Extension { #name : #ZTimestampFormat }

{ #category : #'*ZTimestamp-GT' }
ZTimestampFormat >> gtViewDetailsIn: composite [
	<gtView>
	^ composite columnedList
		title: 'Details';
		items: [ {('specification by example' -> self specification).
			('now utc' -> (self format: ZTimestamp now)).
			('now local' -> (self format: DateAndTime now)).
			('elements' -> (self specificationElements)).
			('timezone' -> (self timezone ifNil: [ #'N/A' ])) } ];
		column: 'Key' text: #key;
		column: 'Value' text: #value;
		send: #value
]
