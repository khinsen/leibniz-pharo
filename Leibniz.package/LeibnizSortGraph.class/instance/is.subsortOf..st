testing
is: aSort subsortOf: anotherSort
	| ss |
	^ (aSort = anotherSort)
		or: [ ss := subsorts at: anotherSort.
				(ss includes: aSort)
				or: [ ss anySatisfy: [:each | self is: aSort subsortOf: each ]]]
