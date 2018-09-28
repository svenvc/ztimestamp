# ZTimestamp

[![Build Status](https://travis-ci.org/svenvc/ztimestamp.svg?branch=master)](https://travis-ci.org/svenvc/ztimestamp)

I am ZTimestamp.


I am a Magnitude.


I represent a point in time, a combination of a date and a time.


I am an alternative for DateAndTime and TimeStamp.  
I have second precision and live in the UTC/GMT/Zulu timezone.  
I use ISO/International conventions and protocols only.   
I support some essential arithmetic.  

I have an efficient internal representation:

	jnd - the julian day number <SmallInteger>
	secs - the number of seconds since midnight, the beginning of the day <SmallInteger>

Examples:

	ZTimestamp now.
	ZTimestamp fromString: '1969-07-20T20:17:40Z'.

There is some compatibility with existing, standard Chronology objects.
I correctly parse representations with a timezone designator
and can print a representation in arbitrary timezones. 

	(ZTimestamp fromString: DateAndTime now truncated printString) localPrintString.


## Time Zone Database
https://www.iana.org/time-zones

Latest data: [tzdata-latest.tar.gz](https://www.iana.org/time-zones/repository/tzdata-latest.tar.gz)

Github repository: https://github.com/eggert/tz


## Formatting & Parsing

Also contains ZTimestampFormat, a 'by example' formatter/parser for DateAndTime, TimeStamp, Date, Time and ZTimestamp.


## SNTP

Also contains ZTimestampSNTPClient, a simple SNTP client to check your local clock.


## Installation

This is a [Pharo Smalltalk](http://wwww.pharo.st) project 
using the [Tonel](https://github.com/pharo-vcs/tonel) source code format.

In Pharo 6.1 and up you can use Iceberg to load this project.

You can also load using the following expression:

    Metacello new
      baseline: 'ZTimestamp';
      repository: 'github://svenvc/ztimestamp';
      load.
   
Written and supported by Sven Van Caekenberghe. MIT Licensed.
