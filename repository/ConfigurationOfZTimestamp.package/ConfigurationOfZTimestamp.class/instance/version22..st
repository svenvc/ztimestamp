versions
version22: spec
	<version: '22' imports: #('1-baseline')>
	
	spec for: #common do: [
		spec
			blessing: #release;
			package: 'ZTimestamp' with: 'ZTimestamp-SvenVanCaekenberghe.63' ]