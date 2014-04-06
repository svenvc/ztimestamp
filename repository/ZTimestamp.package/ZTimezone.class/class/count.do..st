private
count: count do: block
	^ Array new: count streamContents: [ :out |
		count timesRepeat: [ block value: out ] ]