Extension { #name : #ZTimezone }

{ #category : #'*ZTimestamp-GT' }
ZTimezone class >> gtActionReloadAllTimezonesFor: anAction [ 
	<gtClassAction>
	
	^ anAction button
		icon: BrGlamorousVectorIcons refresh;
		tooltip: 'Reload all timezones';
		priority: 10;
		action: [ self reloadAll ]
]

{ #category : #'*ZTimestamp-GT' }
ZTimezone class >> gtSpotterTimezonesFor: aSearch [
	<gtSearch>
	
	^ aSearch list
		priority: 10;
		title: 'Timezones';
		items: [ self timezones values 
			sorted: [ :aTimezone | aTimezone id ] ascending ];
		itemName: [ :aTimezone | aTimezone id  ];
		filterBySubstring
]

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
ZTimezone class >> gtViewTimezonesFor: aView [
	<gtView>
	<gtClassView>
	^ aView columnedList
		title: 'Timezones';
		priority: 10;
		items: [ self timezones values 
			sorted: [ :aTimezone | aTimezone id ] ascending ];
		column: 'Id' text: [ :aTimezone | aTimezone id ];
		column: 'Number of subzones' 
			text: [ :aTimezone | aTimezone subzones size ]
			width: 250;
		actionStencil: [ :aButton | 
				GtSpotterDropdownButtonStencil new
					object: self;
					tooltip: 'Search timezone id';
					id: GtPharoSearchCodeButtonId;
					objectActOn: [ :anActOnEvent :anItem :theButton | 
						(anItem isKindOf: ZTimezone) ifTrue: [ 
							| columnedList |
						
							columnedList := theButton phlow viewContent 
								allChildrenBreadthFirstDetect: [ :child | 
									child isKindOf:  BrColumnedList ] 
								ifFound: [ :child | child ].
							columnedList scrollToItem: anItem.
							columnedList selectOne: (columnedList items indexOf: anItem).
						
							anActOnEvent beActed ] ];
					asElement ]
			tooltip: 'Search timezone id'
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
