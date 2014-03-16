private
resolveUtcIndicators: flags
	self utcIndicators: (self byteArrayToBits: flags)