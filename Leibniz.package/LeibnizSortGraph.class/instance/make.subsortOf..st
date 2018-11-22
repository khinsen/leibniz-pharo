adding
make: aSort subsortOf: anotherSort
	| new_kind |
	(aSort = anotherSort) ifTrue: [ ^ self ].
	(self is: anotherSort subsortOf: aSort)
		ifTrue: [ self error: 'cycle in subsort relation: ',
			                   (anotherSort printString), '<', (aSort printString ) ].
	new_kind := (kinds at: aSort) union: (kinds at: anotherSort).
	(kinds).
	(supersorts at: aSort) add: anotherSort.
	(subsorts at: anotherSort) add: aSort.