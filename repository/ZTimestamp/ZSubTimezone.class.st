"
I am ZSubTimezone.
I represent a specific offset duration to be added to UTC.
I am identified by  an abbreviation.
I know whether daylight saving time is in use or not.

See ZTimezone
"
Class {
	#name : #ZSubTimezone,
	#superclass : #Object,
	#instVars : [
		'abbreviation',
		'offset',
		'isDaylightSaving'
	],
	#category : 'ZTimestamp'
}

{ #category : #'instance creation' }
ZSubTimezone class >> abbreviation: string offset: integer dst: boolean [
	^ self new
		abbreviation: string;
		offset: integer;
		isDaylightSaving: boolean;
		yourself
]

{ #category : #'instance creation' }
ZSubTimezone class >> gmt [
	^ self abbreviation: #GMT offset: 0 dst: false
]

{ #category : #accessing }
ZSubTimezone >> abbreviation [
	^ abbreviation
]

{ #category : #accessing }
ZSubTimezone >> abbreviation: string [
	abbreviation := string asSymbol
]

{ #category : #accessing }
ZSubTimezone >> isDaylightSaving [
	^ isDaylightSaving
]

{ #category : #accessing }
ZSubTimezone >> isDaylightSaving: boolean [
	isDaylightSaving := boolean
]

{ #category : #accessing }
ZSubTimezone >> offset [
	^ offset
]

{ #category : #accessing }
ZSubTimezone >> offset: integer [
	offset := integer asDuration
]

{ #category : #printing }
ZSubTimezone >> printOn: stream [
	super printOn: stream.
	stream nextPut: $(.
	stream << abbreviation; space; print: offset.
	isDaylightSaving ifTrue: [ stream << ' DST' ]. 
	stream nextPut: $)
]
