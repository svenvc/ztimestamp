formatting
format: object
	^ String streamContents: [ :stream |
			self print: object on: stream ]