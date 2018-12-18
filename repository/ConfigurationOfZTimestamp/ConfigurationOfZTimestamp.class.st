"
I am ConfigurationOfZTimestamp, a Metacello configuration to load ZTimestamp.

ZTimestamp, a Magnitude, represents a point in time, a combination of a date and a time.
It is an alternative for DateAndTime and TimeStamp.
It has second precision and lives in the UTC/GMT/Zulu timezone.
It uses ISO/International conventions and protocols only. 
ZTimestamp is more efficient: it uses half the memory of DateAndTime and is faster.

Also contains ZTimestampFormat, a 'by example' formatter/parser for DateAndTime, TimeStamp, Date, Time and ZTimestamp and ZTimestampSNTPClient, a simple SNTP client to check your local clock.
"
Class {
	#name : #ConfigurationOfZTimestamp,
	#superclass : #Object,
	#instVars : [
		'project'
	],
	#classVars : [
		'LastVersionLoad'
	],
	#category : 'ConfigurationOfZTimestamp'
}

{ #category : #'development support' }
ConfigurationOfZTimestamp class >> DevelopmentSupport [

"See the methods in the 'development support' category on the class-side of MetacelloBaseConfiguration. Decide what development support methods you would like to use and copy them the the class-side of your configuration."
	<apiDocumentation>

]

{ #category : #private }
ConfigurationOfZTimestamp class >> baseConfigurationClassIfAbsent: aBlock [

	^Smalltalk
		at: #MetacelloBaseConfiguration
		ifAbsent: [ 
			self ensureMetacelloBaseConfiguration.
			Smalltalk at: #MetacelloBaseConfiguration ifAbsent: aBlock ].

]

{ #category : #catalog }
ConfigurationOfZTimestamp class >> catalogChangeLog [
	"Returns a paragraph describing the most important changes in the configuration class."
	^ 'Started April 2012 with core ZTimestamp as alternative to DateAndTime/Timestamp. Added ZTimestampFormat to format/parse by example in November 2012. Added SNTP client in February 2013. Added ZTimezone support in March 2014'
]

{ #category : #catalog }
ConfigurationOfZTimestamp class >> catalogContactInfo [
	"Returns a paragraph describing contact information such as email, mailing lists and website."
	^ 'Written and maintained by Sven Van Caekenberghe (http://stfx.eu). Discussions on the Pharo aling lists. Documentation can be found at https://github.com/svenvc/docs/blob/master/neo/ztimestamp.md'
]

{ #category : #catalog }
ConfigurationOfZTimestamp class >> catalogDescription [
	"Returns a paragraph describing the project"
	^ 'The ZTimestamp project groups a number of classes that form an addition/alternative to DateAndTime/Timestamp. The core ZTimestamp class represents a point in time, with second precision and always in the UTC/GTM/Zulu timezone. It is faster and smaller. ZTimestampFormat is a formatter and parser that is example based. ZTimezone uses the standard Olsone timezone database to compute the offset for local time at specific points in time for a specified timezone. ZTimestampSNTPClient is an SNTP client to check the local clock against network time servers. This project is small and has no further dependencies. It runs in Pharo 2 and 3.'
]

{ #category : #catalog }
ConfigurationOfZTimestamp class >> catalogKeyClassesAndExample [
	"Returns a paragraph or more describing the key classes of your project. You can use Pillar/Pier syntax to layout out the text i.e., ==Code== and - for bullet."
	^ 'The core classes are ZTimestamp to represent a point in time, ZTimestampFormat to format and parse chronology objects by example, ZTimezone to compute local time offsets and ZTimestampSNTPClient to check the clock against an network time server.'
]

{ #category : #catalog }
ConfigurationOfZTimestamp class >> catalogKeywords [
	"Returns an array of symbols"
	^ #(timestamp time date chronology parsing formatting timezone sntp) 
]

{ #category : #private }
ConfigurationOfZTimestamp class >> ensureMetacello [

	(self baseConfigurationClassIfAbsent: []) ensureMetacello
]

{ #category : #private }
ConfigurationOfZTimestamp class >> ensureMetacelloBaseConfiguration [

	Smalltalk
		at: #MetacelloBaseConfiguration
		ifAbsent: [ 
			| repository version |
			repository := MCHttpRepository location: 'http://seaside.gemstone.com/ss/metacello' user: '' password: ''.
			repository
				versionReaderForFileNamed: 'Metacello-Base-DaleHenrichs.2.mcz'
				do: [ :reader | 
					version := reader version.
					version load.
					version workingCopy repositoryGroup addRepository: repository ] ]
]

{ #category : #'metacello tool support' }
ConfigurationOfZTimestamp class >> isMetacelloConfig [
	"Answer true and the Metacello tools will operate on you"
	
	^true
]

{ #category : #loading }
ConfigurationOfZTimestamp class >> load [
	"Load the #stable version defined for this platform. The #stable version is the version that is recommended to be used on this platform."

	"self load"

	<apiDocumentation>
	^(self project version: #stable) load
]

{ #category : #loading }
ConfigurationOfZTimestamp class >> loadBleedingEdge [
	"Load the latest versions of the mcz files defined for this project. It is not likely that the #bleedingEdge has been tested."

	"self loadBleedingEdge"

	<apiDocumentation>
	^(self project version: #bleedingEdge) load
]

{ #category : #loading }
ConfigurationOfZTimestamp class >> loadDevelopment [
	"Load the #development version defined for this platform. The #development version will change over time and is not expected to be stable."

	"self loadDevelopment"

	<apiDocumentation>
	^(self project version: #development) load
]

{ #category : #accessing }
ConfigurationOfZTimestamp class >> project [

	^self new project
]

{ #category : #'development support' }
ConfigurationOfZTimestamp class >> validate [
	"Check the configuration for Errors, Critical Warnings, and Warnings (see class comment for MetacelloMCVersionValidator for more information). 
	Errors identify specification issues that will result in unexpected behaviour when you load the configuration. 
	Critical Warnings identify specification issues that may result in unexpected behavior when you load the configuration.
	Warnings identify specification issues that are technically correct, but are worth take a look at."

	"self validate"

	<apiDocumentation>
	self ensureMetacello.
	^ ((Smalltalk at: #MetacelloToolBox) validateConfiguration: self debug: #() recurse: false) explore
]

{ #category : #baselines }
ConfigurationOfZTimestamp >> baseline1: spec [
	<version: '1-baseline'>
	
	spec for: #common do: [
		spec 
			blessing: #baseline;
			repository: 'http://mc.stfx.eu/Neo';
			package: 'ZTimestamp' ]
]

{ #category : #accessing }
ConfigurationOfZTimestamp >> project [

	^ project ifNil: [ | constructor |
		"Bootstrap Metacello if it is not already loaded"
		(self class baseConfigurationClassIfAbsent: []) ensureMetacello.
		"Construct Metacello project"
		constructor := (Smalltalk at: #MetacelloVersionConstructor) on: self.
		project := constructor project.
		project loadType: #linear. "change to #atomic if desired"
		project ]
]

{ #category : #'symbolic versions' }
ConfigurationOfZTimestamp >> stable: spec [
	<symbolicVersion: #'stable'>
	
	spec for: #common version: '24'. "pharo 6.1 and higher track the latest-release git branch"

	spec for: #'pharo3.x' version: '23'.
	spec for: #'pharo4.x' version: '23'.
	spec for: #'pharo5.x' version: '23'.
	spec for: #'pharo6.0' version: '23'.
]

{ #category : #versions }
ConfigurationOfZTimestamp >> version10: spec [
	<version: '10' imports: #('1-baseline')>
	
	spec for: #common do: [
		spec
			blessing: #release;
			package: 'ZTimestamp' with: 'ZTimestamp-SvenVanCaekenberghe.29' ]
]

{ #category : #versions }
ConfigurationOfZTimestamp >> version11: spec [
	<version: '11' imports: #('1-baseline')>
	
	spec for: #common do: [
		spec
			blessing: #release;
			package: 'ZTimestamp' with: 'ZTimestamp-SvenVanCaekenberghe.30' ]
]

{ #category : #versions }
ConfigurationOfZTimestamp >> version12: spec [
	<version: '12' imports: #('1-baseline')>
	
	spec for: #common do: [
		spec
			blessing: #release;
			package: 'ZTimestamp' with: 'ZTimestamp-SvenVanCaekenberghe.31' ]
]

{ #category : #versions }
ConfigurationOfZTimestamp >> version13: spec [
	<version: '13' imports: #('1-baseline')>
	
	spec for: #common do: [
		spec
			blessing: #release;
			package: 'ZTimestamp' with: 'ZTimestamp-SvenVanCaekenberghe.32' ]
]

{ #category : #versions }
ConfigurationOfZTimestamp >> version14: spec [
	<version: '14' imports: #('1-baseline')>
	
	spec for: #common do: [
		spec
			blessing: #release;
			package: 'ZTimestamp' with: 'ZTimestamp-SvenVanCaekenberghe.33' ]
]

{ #category : #versions }
ConfigurationOfZTimestamp >> version15: spec [
	<version: '15' imports: #('1-baseline')>
	
	spec for: #common do: [
		spec
			blessing: #release;
			package: 'ZTimestamp' with: 'ZTimestamp-SvenVanCaekenberghe.34' ]
]

{ #category : #versions }
ConfigurationOfZTimestamp >> version16: spec [
	<version: '16' imports: #('1-baseline')>
	
	spec for: #common do: [
		spec
			blessing: #release;
			package: 'ZTimestamp' with: 'ZTimestamp-SvenVanCaekenberghe.43' ]
]

{ #category : #versions }
ConfigurationOfZTimestamp >> version17: spec [
	<version: '17' imports: #('1-baseline')>
	
	spec for: #common do: [
		spec
			blessing: #release;
			package: 'ZTimestamp' with: 'ZTimestamp-SvenVanCaekenberghe.47' ]
]

{ #category : #versions }
ConfigurationOfZTimestamp >> version18: spec [
	<version: '18' imports: #('1-baseline')>
	
	spec for: #common do: [
		spec
			blessing: #release;
			package: 'ZTimestamp' with: 'ZTimestamp-SvenVanCaekenberghe.51' ]
]

{ #category : #versions }
ConfigurationOfZTimestamp >> version19: spec [
	<version: '19' imports: #('1-baseline')>
	
	spec for: #common do: [
		spec
			blessing: #release;
			package: 'ZTimestamp' with: 'ZTimestamp-SvenVanCaekenberghe.53' ]
]

{ #category : #versions }
ConfigurationOfZTimestamp >> version1: spec [
	<version: '1' imports: #('1-baseline')>
	
	spec for: #common do: [
		spec
			blessing: #release;
			package: 'ZTimestamp' with: 'ZTimestamp-SvenVanCaekenberghe.11' ]
]

{ #category : #versions }
ConfigurationOfZTimestamp >> version20: spec [
	<version: '20' imports: #('1-baseline')>
	
	spec for: #common do: [
		spec
			blessing: #release;
			package: 'ZTimestamp' with: 'ZTimestamp-SvenVanCaekenberghe.57' ]
]

{ #category : #versions }
ConfigurationOfZTimestamp >> version21: spec [
	<version: '21' imports: #('1-baseline')>
	
	spec for: #common do: [
		spec
			blessing: #release;
			package: 'ZTimestamp' with: 'ZTimestamp-SvenVanCaekenberghe.61' ]
]

{ #category : #versions }
ConfigurationOfZTimestamp >> version22: spec [
	<version: '22' imports: #('1-baseline')>
	
	spec for: #common do: [
		spec
			blessing: #release;
			package: 'ZTimestamp' with: 'ZTimestamp-SvenVanCaekenberghe.63' ]
]

{ #category : #versions }
ConfigurationOfZTimestamp >> version23: spec [
	<version: '23' imports: #('1-baseline')>
	
	spec for: #common do: [
		spec
			blessing: #release;
			package: 'ZTimestamp' with: 'ZTimestamp-SvenVanCaekenberghe.68' ]
]

{ #category : #versions }
ConfigurationOfZTimestamp >> version24: spec [
	<version: '24'>
	spec for: #common do: [ 
		spec
			blessing: #release;
			baseline: 'ZTimestamp'
			with: [
				"This refers to the latest-release branch to follow releases automatically" 
				spec
					className: 'BaselineOfZTimestamp';
					repository: 'github://svenvc/ztimestamp:latest-release' ] ]
]

{ #category : #versions }
ConfigurationOfZTimestamp >> version2: spec [
	<version: '2' imports: #('1-baseline')>
	
	spec for: #common do: [
		spec
			blessing: #release;
			package: 'ZTimestamp' with: 'ZTimestamp-SvenVanCaekenberghe.12' ]
]

{ #category : #versions }
ConfigurationOfZTimestamp >> version3: spec [
	<version: '3' imports: #('1-baseline')>
	
	spec for: #common do: [
		spec
			blessing: #release;
			package: 'ZTimestamp' with: 'ZTimestamp-SvenVanCaekenberghe.15' ]
]

{ #category : #versions }
ConfigurationOfZTimestamp >> version4: spec [
	<version: '4' imports: #('1-baseline')>
	
	spec for: #common do: [
		spec
			blessing: #release;
			package: 'ZTimestamp' with: 'ZTimestamp-SvenVanCaekenberghe.16' ]
]

{ #category : #versions }
ConfigurationOfZTimestamp >> version5: spec [
	<version: '5' imports: #('1-baseline')>
	
	spec for: #common do: [
		spec
			blessing: #release;
			package: 'ZTimestamp' with: 'ZTimestamp-SvenVanCaekenberghe.19' ]
]

{ #category : #versions }
ConfigurationOfZTimestamp >> version6: spec [
	<version: '6' imports: #('1-baseline')>
	
	spec for: #common do: [
		spec
			blessing: #release;
			package: 'ZTimestamp' with: 'ZTimestamp-SvenVanCaekenberghe.20' ]
]

{ #category : #versions }
ConfigurationOfZTimestamp >> version7: spec [
	<version: '8' imports: #('1-baseline')>
	
	spec for: #common do: [
		spec
			blessing: #release;
			package: 'ZTimestamp' with: 'ZTimestamp-SvenVanCaekenberghe.22' ]
]

{ #category : #versions }
ConfigurationOfZTimestamp >> version8: spec [
	<version: '8' imports: #('1-baseline')>
	
	spec for: #common do: [
		spec
			blessing: #release;
			package: 'ZTimestamp' with: 'ZTimestamp-SvenVanCaekenberghe.28' ]
]

{ #category : #versions }
ConfigurationOfZTimestamp >> version9: spec [
	<version: '9' imports: #('1-baseline')>
	
	spec for: #common do: [
		spec
			blessing: #release;
			package: 'ZTimestamp' with: 'ZTimestamp-SvenVanCaekenberghe.28' ]
]
