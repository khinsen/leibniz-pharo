testing
testSortGraphContents
   self assert: sortGraph1 asSet equals: #(#A #B #C #D) asSet.
	self assert: (sortGraph1 includes: #A).
	self assert: (sortGraph1 includes: #B).
	self assert: (sortGraph1 includes: #C).
	self assert: (sortGraph1 includes: #D).
	self deny: (sortGraph1 includes: #E).
	self assert: (sortGraph1 is: #A subsortOf: #A).
	self assert: (sortGraph1 is: #A subsortOf: #B).
	self assert: (sortGraph1 is: #B subsortOf: #C).
	self assert: (sortGraph1 is: #A subsortOf: #D).
	self assert: (sortGraph1 is: #A subsortOf: #C).
	self deny: (sortGraph1 is: #C subsortOf: #A).
	self deny: (sortGraph1 is: #B subsortOf: #D).
