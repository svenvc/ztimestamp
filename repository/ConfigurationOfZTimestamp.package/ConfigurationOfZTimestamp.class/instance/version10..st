versions
version10: spec
	<version: '10' imports: #('1-baseline')>
	
	spec for: #common do: [
		spec
			blessing: #release;
			package: 'ZTimestamp' with: 'ZTimestamp-SvenVanCaekenberghe.29' ]