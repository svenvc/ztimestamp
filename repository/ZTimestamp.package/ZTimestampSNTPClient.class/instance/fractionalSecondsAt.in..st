private
fractionalSecondsAt: offset in: bytes
	^ (bytes copyFrom: offset to: offset + 3) asInteger / (2 raisedToInteger: 32)