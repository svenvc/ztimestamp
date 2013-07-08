formatting
format: object
	^ String streamContents: [ :stream |
			self format: object on: stream ]