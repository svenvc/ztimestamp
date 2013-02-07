accessing
formatSpecifications
	^ #(
		'2001' 		yearFull
		'01' 			yearTwoDigits
		'02'			monthTwoDigits
		'2'				month
		'Februari'	monthNameCapitalized
		'februari'		monthNameLowercased
		'FEBRUARI'	monthNameUppercased
		'Feb'			monthNameAbbreviatedCapitalized
		'feb'			monthNameAbbreviatedLowercased
		'FEB'			monthNameAbbreviatedUppercased
		'3'				day
		'_3'			dayTwoDigitsSpacePadded
		'03'			dayTwoDigits
		'4'				hour12
		'04'			hour12TwoDigits
		'16'			hour24TwoDigits
		'PM'			daypartUppercased
		'pm'			daypartLowercased
		'5'				minute
		'05'			minuteTwoDigits
		'6'				second
		'06'			secondTwoDigits
		'Z'				timeZoneZ
		'+00:00'		timeZone
		'UTC'			timeZoneAbbreviated
		'Saterday'	weekdayNameCapitalized
		'saterday'	weekdayNameLowercased
		'SATERDAY'	weekdayNameUppercased
		'Sat'			weekdayNameAbbreviatedCapitalized
		'sat'			weekdayNameAbbreviatedLowercased
		'SAT'			weekdayNameAbbreviatedUppercased )