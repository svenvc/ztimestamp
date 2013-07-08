private
fullSecondsAt: offset in: bytes
	^ (bytes copyFrom: offset to: offset + 3) asInteger