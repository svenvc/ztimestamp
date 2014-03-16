instance creation
abbreviation: string offset: integer dst: boolean
	^ self new
		abbreviation: string;
		offset: integer;
		isDaylightSaving: boolean;
		yourself