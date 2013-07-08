private
timestampAt: offset in: bytes
	| seconds fractions |
	seconds := self fullSecondsAt: offset in: bytes.	
	fractions := self fractionalSecondsAt: offset + 4 in: bytes.
	^ self timestampFromSeconds: seconds fraction: fractions