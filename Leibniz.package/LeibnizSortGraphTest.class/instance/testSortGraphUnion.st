testing
testSortGraphUnion
	| union1 union2 |
	union1 := (sortGraph1 union: sortGraph2).
	union2 := (sortGraph2 union: sortGraph1).
	self assert: union1 equals: union2.
	self assert: (union1 asSet) equals: (sortGraph1 asSet union: sortGraph2 asSet). 
	self assert: (union1 includes: #A).
	self assert: (union1 includes: #X).
	self assert: (union1 is: #A subsortOf: #C).
	self assert: (union1 is: #A subsortOf: #X).
	self assert: (sortGraph1 union: sortGraph1) equals: sortGraph1.
	self assert: (sortGraph1 union: sortGraph1 class new) equals: sortGraph1.
