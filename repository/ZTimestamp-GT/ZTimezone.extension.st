Extension { #name : #ZTimezone }

{ #category : #'*ZTimestamp-GT' }
ZTimezone >> gtViewDetailsIn: composite [
	<gtView>
	^ composite columnedList
		title: 'Details';
		items: [ {('id' -> self id).
			('current offset' -> (self offsetForTimestamp: ZTimestamp now)).
			('current subzone' -> (self subzoneForTimestamp: ZTimestamp now)) } ];
		column: 'Key' text: #key;
		column: 'Value' text: #value;
		send: #value
]

{ #category : #'*ZTimestamp-GT' }
ZTimezone >> gtViewTransitionsIn: composite [
	<gtView>
	^ composite columnedList
		title: 'Transitions';
		items: [ self resolvedTransitions ];
		column: 'Start' text: #key;
		column: 'Subzone' text: #value;
		send: #value
]
