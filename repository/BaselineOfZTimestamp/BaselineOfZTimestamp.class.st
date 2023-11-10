"
I am BaselineOfZTimestamp, a Metacello baseline to load ZTimestamp.

ZTimestamp, a Magnitude, represents a point in time, a combination of a date and a time.
It is an alternative for DateAndTime and TimeStamp.
It has nanosecond precision and lives in the UTC/GMT/Zulu timezone.
It uses ISO/International conventions and protocols only. 
ZTimestamp is more efficient: it uses half the memory of DateAndTime and is faster.

Also contains:

ZTimestampFormat, a 'by example' formatter/parser for DateAndTime, TimeStamp, Date, Time and ZTimestamp 

ZTimestampSNTPClient, a simple SNTP client to check your local clock

ZTimezone, access to the timezone information in the standard Olsen database.
"
Class {
	#name : #BaselineOfZTimestamp,
	#superclass : #BaselineOf,
	#category : #BaselineOfZTimestamp
}

{ #category : #baselines }
BaselineOfZTimestamp >> baseline: spec [
	<baseline> 
	
	spec for: #common do: [
		spec 
			package: 'ZTimestamp-Core';
			package: 'ZTimestamp-Tests' with: [ spec requires: #('ZTimestamp-Core') ];
			group: 'default' with: #('core' 'tests');
			group: 'core' with: #('ZTimestamp-Core');
			group: 'tests' with: #('ZTimestamp-Tests') ]
]
