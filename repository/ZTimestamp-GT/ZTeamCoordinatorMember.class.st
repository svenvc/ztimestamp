"
I am ZTeamCoordinatorMember.

I am used together with ZTeamCoordinator.

I  hold a name and timezone (ZTimezone).
"
Class {
	#name : #ZTeamCoordinatorMember,
	#superclass : #Object,
	#instVars : [
		'name',
		'timezone'
	],
	#category : #'ZTimestamp-GT'
}

{ #category : #accessing }
ZTeamCoordinatorMember class >> example [
	<gtExample>
	^ self new
		name: 'sven';
		timezone: (ZTimezone id: 'Europe/Brussels');
		yourself
]

{ #category : #accessing }
ZTeamCoordinatorMember >> gtViewDetailsIn: composite [
	<gtView>
	| now difference |
	now := ZTimestamp now.
	difference := (self timezone offsetForTimestamp: now) 
					- (ZTimezone current offsetForTimestamp: now).
	^ composite columnedList
		title: 'Details';
		items: [ {
			('name' -> self name).
			('timezone' -> self timezone id).
			('clock' -> ((ZTimestampFormat fromString: '16:05') 
				timezone: self timezone; 
				format: now )).
			('offset' -> ((ZTimestampFormat fromString: 'GMT+00:00') 
				timezone: self timezone; 
				format: now)).
			('difference' -> (difference isZero 
				ifTrue: [ 0 ]
				ifFalse: [ difference humanReadablePrintString ]))} ];
		column: 'Key' text: #key;
		column: 'Value' text: #value;
		send: #value
]

{ #category : #accessing }
ZTeamCoordinatorMember >> name [
	^ name
]

{ #category : #accessing }
ZTeamCoordinatorMember >> name: anObject [
	name := anObject
]

{ #category : #printing }
ZTeamCoordinatorMember >> printOn: stream [
	super printOn: stream.
	stream nextPut: $(; print: self name; nextPut: $)
]

{ #category : #accessing }
ZTeamCoordinatorMember >> timezone [
	^ timezone
]

{ #category : #accessing }
ZTeamCoordinatorMember >> timezone: anObject [
	timezone := anObject
]
