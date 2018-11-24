testing
testSubsortQueries
	self assert: (sortGraph1 directSubsortsOf: #A) equals: Set new.
	self assert: (sortGraph1 subsortsOf: #B) equals: (Set with: #A).
	self assert: (sortGraph1 directSubsortsOf: #B) equals: (Set with: #A).
	self assert: (sortGraph1 subsortsOf: #B) equals: (Set with: #A).
	self assert: (sortGraph1 directSubsortsOf: #C) equals: (Set with: #B).
	self assert: (sortGraph1 subsortsOf: #C) equals: #(#A #B) asSet.
	self assert: (sortGraph1 directSubsortsOf: #D) equals: (Set with: #A).
	self assert: (sortGraph1 subsortsOf: #D) equals: (Set with: #A).
