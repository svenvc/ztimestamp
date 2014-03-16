private
checkMagicFrom: in
	| version |
	self assert: (in next: 4) = 'TZif' asByteArray.
	version := in next.
	"version 0 is the traditional format.
	version 2 means that the normal data is followed an identical format
	where the offsets are specified using 8 instead of 4 bytes for future proofing"
	in skip: 15