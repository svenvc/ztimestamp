versions
version7: spec
	<version: '8' imports: #('1-baseline')>
	
	spec for: #common do: [
		spec
			blessing: #release;
			package: 'ZTimestamp' with: 'ZTimestamp-SvenVanCaekenberghe.22' ]