I am ZTimezone, representing the timezone information in the standard Olsen database.

  http://en.wikipedia.org/wiki/Tz_database

Usage

You reference timezones by their ID. The list of supported identifiers is accessible using

  ZTimezone timezoneIdentifiers.

To access a timezone do

  ZTimezone id: 'Europe/Brussels'.

The necessary information will be loaded, parsed and cached from a binary file of the zoneinfo database (see also man tzfile). This should work automagically on Mac OS X and Unix, on Windows you have to download the necessary files and specify their location 

  ZTimezone zoneInfoLocation: FileLocator C / 'foo' / 'bar' / 'zoneinfo'.

Once you get a handle on a timezone, the main operation is to query the sub timezone that is applicable at a certain point in time 

  (ZTimezone id: 'Europe/Brussels') subzoneForTimestamp: ZTimestamp now.

The ZSubTimezone instance returned contains information like the UTC offset. Since you'll probably only be interested in that aspect there is a convenience method 

  (ZTimezone id: 'Europe/Brussels') offsetForTimestamp: DateAndTime now.

The flow is that for every GMT timestamp, you get the concrete offset to use for a specific timezone. Note that this is not a constant, it depends on the time periode the timestamp falls in.

The are 2 more convenience methods to quickly convert between GTM and local wall time 

  (ZTimezone id: #'Europe/Brussels') gmtToLocal: ZTimestamp now.
  (ZTimezone id: #'Europe/Brussels') localToGmt: DateAndTime now.

Also note the zoneTab and the timezones are cached in the image. When the TZ database changes, it might be necessary to either call #cleanUp or #reloadAll. When moving images between machines, either all info should be loaded and cached, or it might be necessary to use #zoneInfoLocation: again.

Implementation

A chronological array of transition points in unix time specifies which sub zone is active from that point on to the next.

Limitations

The format 2 data following the format 1 data is not read as it is a duplicate. Leap seconds, the standard/wall indicators and the UTC/local indicators are currently ignored, but their information is read and stored.