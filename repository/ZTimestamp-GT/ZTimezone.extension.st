Extension { #name : #ZTimezone }

{ #category : #'*ZTimestamp-GT' }
ZTimezone class >> gtActionReloadAllTimezonesFor: anAction [ 
	<gtClassAction>
	
	^ anAction button
		icon: BrGlamorousVectorIcons refresh;
		tooltip: 'Reload and cache all timezones';
		priority: 10;
		action: [ self reloadAll ]
]

{ #category : #'*ZTimestamp-GT' }
ZTimezone class >> gtSpotterCachedTimezonesFor: aSearch [
	<gtSearch>
	^ aSearch list
		priority: 10;
		title: 'Cached timezones';
		items: [ self timezones values 
			sorted: [ :aTimezone | aTimezone id ] ascending ];
		itemName: [ :aTimezone | aTimezone id  ];
		filterBySubstring
]

{ #category : #'*ZTimestamp-GT' }
ZTimezone class >> gtSpotterTimezoneIdentifiersFor: aSearch [
	<gtSearch>
	^ aSearch list
		priority: 11;
		title: 'Timezone identifiers';
		items: [ self timezoneIdentifiers sorted: #yourself ascending ];
		itemName: [ :id | id ];
		send: [ :id | ZTimezone id: id ];
		filterBySubstring
]

{ #category : #'*ZTimestamp-GT' }
ZTimezone class >> gtViewCachedTimezonesFor: aView [
	<gtView>
	<gtClassView>
	^ aView columnedList
		title: 'Cached timezones';
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
					tooltip: 'Search cached timezones by id';
					id: GtPharoSearchCodeButtonId;
					objectActOn: [ :anActOnEvent :anItem :theButton | 
						| targetTimezone |
						targetTimezone := anActOnEvent objectToSend.
						(targetTimezone isKindOf: ZTimezone) 
							ifTrue: [ 
								| columnedList |
						
								columnedList := theButton phlow viewContent 
									allChildrenBreadthFirstDetect: [ :child | 
										child isKindOf:  BrColumnedList ] 
									ifFound: [ :child | child ].
								columnedList scrollToItem: targetTimezone.
								columnedList selectOne: (columnedList items 
									indexOf: targetTimezone).
								
								anActOnEvent beActed ] ];
					asElement ]
			tooltip: 'Search cached timezones by id'
]

{ #category : #'*ZTimestamp-GT' }
ZTimezone class >> gtViewCurrentTimezoneIn: composite [
	<gtView>
	<gtClassView>
	^ composite columnedList
		title: 'Current';
		priority: 11;
		items: [ {('image default' -> self current id)} ];
		column: 'Key' text: #key;
		column: 'Value' text: #value;
		send: [ self current ]
]

{ #category : #'*ZTimestamp-GT' }
ZTimezone >> gtViewDetailsIn: composite [
	<gtView>
	^ composite columnedList
		title: 'Details';
		items: [ {('id' -> self id).
			('now' -> (ZTimestampFormat isoNanoTZ timezone: self; format: ZTimestamp now)).
			('current offset' -> (self offsetForTimestamp: ZTimestamp now)).
			('currently daylight saving' -> (self subzoneForTimestamp: ZTimestamp now) isDaylightSaving).
			('current subzone' -> (self subzoneForTimestamp: ZTimestamp now) description ) } ];
		column: 'Key' text: #key;
		column: 'Value' text: #value;
		send: #value
]

{ #category : #'*ZTimestamp-GT' }
ZTimezone class >> gtViewTimezoneIdentifiersFor: aView [
	<gtView>
	<gtClassView>
	^ aView columnedList
		title: 'Timezone identifiers';
		priority: 9;
		items: [ self timezoneIdentifiers sorted: #yourself ascending ];
		column: 'Id' text: [ :id | id ];
		send: [ :id | ZTimezone id: id ];
		actionStencil: [ :aButton | 
				GtSpotterDropdownButtonStencil new
					object: self;
					tooltip: 'Search timezone identifiers';
					id: GtPharoSearchCodeButtonId;
					objectActOn: [ :anActOnEvent :anItem :theButton | 
						| targetTimezone |
						targetTimezone := anActOnEvent objectToSend.
						(targetTimezone isKindOf: ZTimezone) 
							ifTrue: [ 
								| columnedList |
						
								columnedList := theButton phlow viewContent 
									allChildrenBreadthFirstDetect: [ :child | 
										child isKindOf:  BrColumnedList ] 
									ifFound: [ :child | child ].
								columnedList scrollToItem: targetTimezone id.
								columnedList selectOne: (columnedList items 
									indexOf: targetTimezone id) ].
						anActOnEvent beActed ];
					asElement ]
			tooltip: 'Search timezone identifiers'
]

{ #category : #'*ZTimestamp-GT' }
ZTimezone >> gtViewTransitionsIn: composite [
	<gtView>
	^ composite columnedList
		title: 'Transitions';
		items: [ self resolvedTransitions ];
		column: 'Start absolute' 
			text: [ :association | association key ];
		column: 'Start local' 
			text: [ :association | 
				((ZTimestampFormat fromString: '2001-02-03 T 16:05:06+00:00') timezone: self; format: association key - 1 second) , 
				' > ' , 
				((ZTimestampFormat fromString: '16:05:06+00:00') timezone: self; format: association key) ];
		column: ('Start ' , ZCurrentTimezone value id) 
			text: [ :association | ZTimestampFormat isoTZ useCurrentTimezone; format: association key ];
		column: 'Subzone' text: [ :association | association value description ]
]
