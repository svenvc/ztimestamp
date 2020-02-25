"
I am ZCurrentTimezone.
I am a DynamicVariable.

I am used to hold the default timezone to use to render UTC/GMT/Zulu timestamps to local time representations.

I am also used to hold the default timezone to parse local time representations into UTC/GMT/Zulu timestamps.

My default is the value returned by ZTimezone current.

Any object that responds to #offsetForTimestamp: can be a timezone.

	ZCurrentTimezone value.
	
	ZCurrentTimezone 
		value: (ZTimezone id: 'Europe/Brussels') 
		during: [ ZCurrentTimezone value ].

"
Class {
	#name : #ZCurrentTimezone,
	#superclass : #DynamicVariable,
	#category : #ZTimestamp
}

{ #category : #accessing }
ZCurrentTimezone >> default [
	^ ZTimezone current
]
