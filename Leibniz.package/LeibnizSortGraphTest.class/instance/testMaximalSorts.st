testing
testMaximalSorts
	self assert: (sortGraph1 maximalSorts: sortGraph1 asSet) equals: #(#C #D) asSet.
	self assert: (sortGraph3 maximalSorts: sortGraph3 asSet) equals: #(#C #D #W) asSet.
