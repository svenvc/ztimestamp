versions
version16: spec
	<version: '16' imports: #('1-baseline')>
	
	spec for: #common do: [
		spec
			blessing: #release;
			package: 'ZTimestamp' with: 'ZTimestamp-SvenVanCaekenberghe.43' ]