Extension { #name : #String }

{ #category : #'*ZTimestamp-Core' }
String >> asZTimestamp [
	"Try parsing me into a ZTimestamp and return it. 
	A flexible ISO 8601 representation is supported."
	
	"'1969-07-20T20:17:40Z' asZTimestamp"
	"'1969/07/20 20:17:40+00:00' asZTimestamp"
	"'19690720T201740Z' asZTimestamp"
	"'19690720' asZTimestamp"
	
	^ ZTimestamp fromString: self
]
