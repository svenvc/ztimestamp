accessing
localTransitions
	"Lazily computed transition table in local wall time"

	^ localTransitions
		ifNil: [ 
			localTransitions := self transitions
				withIndexCollect: [ :each :index | 
					each + (self subzoneForTransitionAt: index) offset asSeconds ] ]