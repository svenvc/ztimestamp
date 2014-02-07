I am ConfigurationOfZTimestamp, a Metacello configuration to load ZTimestamp.

ZTimestamp, a Magnitude, represents a point in time, a combination of a date and a time.
It is an alternative for DateAndTime and TimeStamp.
It has second precision and lives in the UTC/GMT/Zulu timezone.
It uses ISO/International conventions and protocols only. 
ZTimestamp is more efficient: it uses half the memory of DateAndTime and is faster.

Also contains  ZTimestampFormat, a 'by example' formatter/parser for DateAndTime, TimeStamp, Date, Time and ZTimestamp and ZTimestampSNTPClient, a simple SNTP client to check your local clock.