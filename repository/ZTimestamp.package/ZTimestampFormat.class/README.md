I am ZTimestampFormat, an implementation of a textual representation for a timestamp, date or time that can be used for formatting or parsing.

You instanciate me by specifying the textual format by example, based on a #reference timetamp. 
Each component of the example representation is numbered from largest to smallest unit:
	1=year
	2=month
	3=dayInMonth
	4=hour (16 in 24 hour format)
	5=minute
	6=second
as in the ISO representation: 
	2001-02-03T16:05:06Z which is a Saterday. 
Example format strings can be found in my class accessing protocol or in the unit tests.

To specifiy a format, you write the reference date so that it matches the representation that you want.

	(ZTimestampFormat fromString: 'SAT, FEB 03 2001 (16:05:06)')
		format: ZTimestamp now.

I can be used for unabiguous, stricter parsing as well.

	(ZTimestampFormat fromString: '02/03/01 (16:05:06)')
		parse: '10/10/10 (12:01:01)'.
		
The list of possible keys and their interpretation #formatSpecifications.
I can translate month and weekday names to 4 different languages, English, French, German and Dutch.
I can optionally use a timezone to convert UTC/GMT/Zulu timestamps to local time.