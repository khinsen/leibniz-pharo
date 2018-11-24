testing
testKinds
	| set1 |
	set1 := sortGraph1 asSet.
	set1 do: [ :sort | self assert: (sortGraph1 kindOf: sort) equals: set1 ].
	self assert: (sortGraph3 kindOf: #A) equals: #(#A #B #C #D) asSet.
	self assert: (sortGraph3 kindOf: #V) equals: #(#V #W) asSet.
