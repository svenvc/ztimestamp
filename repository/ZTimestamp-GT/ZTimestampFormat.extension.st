Extension { #name : #ZTimestampFormat }

{ #category : #'*ZTimestamp-GT' }
ZTimestampFormat >> gtViewDetailsIn: composite [
	<gtView>
	^ composite columnedList
		title: 'Details';
		items: [ {('specification by example' -> self specification).
			('now' -> (self format: ZTimestamp now)).
			('elements' -> (self specificationElements)).
			('timezone' -> (self timezone ifNil: [ #UTC ])) } ];
		column: 'Key' text: #key;
		column: 'Value' text: #value;
		send: #value
]
