"
I represent a sort graph in a Leibniz context.
"
Class {
	#name : #LeibnizSortGraph,
	#superclass : #Object,
	#instVars : [
		'subsortsOf',
		'supersortsOf',
		'sameKindSortsOf'
	],
	#category : #'Leibniz-Core'
}

{ #category : #comparing }
LeibnizSortGraph >> = aSortGraph [
	^ aSortGraph privateEqualityTestWith: sameKindSortsOf and: supersortsOf and: subsortsOf
]

{ #category : #adding }
LeibnizSortGraph >> add: aSymbol [
   (self includes: aSymbol)
     ifFalse: [ sameKindSortsOf at: aSymbol put: (Set with: aSymbol).
                supersortsOf at: aSymbol put: Set new.
                subsortsOf at: aSymbol put: Set new. ].
   ^ aSymbol

]

{ #category : #converting }
LeibnizSortGraph >> asSet [
   ^ sameKindSortsOf keys asSet 

]

{ #category : #accessing }
LeibnizSortGraph >> directSubsortsOf: aSymbol [
	^ subsortsOf at: aSymbol.
]

{ #category : #viewing }
LeibnizSortGraph >> gtInspectorViewIn: composite [
	<gtInspectorPresentationOrder: -10>
	composite roassal2
		title: 'View';
		initializeView: self view.

]

{ #category : #comparing }
LeibnizSortGraph >> hash [
	^ sameKindSortsOf hash
	
]

{ #category : #testing }
LeibnizSortGraph >> includes: aSort [
	^ sameKindSortsOf keys includes: aSort

]

{ #category : #initializing }
LeibnizSortGraph >> initialize [
   sameKindSortsOf := Dictionary new.
	subsortsOf := Dictionary new.
	supersortsOf := Dictionary new
]

{ #category : #testing }
LeibnizSortGraph >> is: aSort subsortOf: anotherSort [
	| ss |
	^ (aSort = anotherSort)
		or: [ ss := subsortsOf at: anotherSort.
				(ss includes: aSort)
				or: [ ss anySatisfy: [:each | self is: aSort subsortOf: each ]]]

]

{ #category : #accessing }
LeibnizSortGraph >> kindOf: aSymbol [
	^ self subGraphForSorts: (sameKindSortsOf at: aSymbol)
]

{ #category : #accessing }
LeibnizSortGraph >> kinds [
	| k |
	k := Set new.
	sameKindSortsOf values asSet do:
		[ :sorts | k add: (self subGraphForSorts: sorts) ].
	^ k
]

{ #category : #adding }
LeibnizSortGraph >> make: aSort subsortOf: anotherSort [
	| new_kind |
	(aSort = anotherSort) ifTrue: [ ^ self ].
	(self is: anotherSort subsortOf: aSort)
		ifTrue: [ self error: 'cycle in subsort relation: ',
			                   (anotherSort printString), '<', (aSort printString ) ].
	new_kind := (sameKindSortsOf at: aSort) union: (sameKindSortsOf at: anotherSort).
	new_kind do: [ :sort | sameKindSortsOf at: sort put: new_kind].
	(supersortsOf at: aSort) add: anotherSort.
	(subsortsOf at: anotherSort) add: aSort.
]

{ #category : #accessing }
LeibnizSortGraph >> maximalSorts [
	^  self selectMaximalSortsFrom: self asSet.
]

{ #category : #copying }
LeibnizSortGraph >> postCopy [
	super postCopy.
	sameKindSortsOf := sameKindSortsOf deepCopy.
	supersortsOf := supersortsOf deepCopy.
	subsortsOf := subsortsOf deepCopy.
]

{ #category : #printing }
LeibnizSortGraph >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	aStream nextPutAll: (', ' join: (self maximalSorts collect: [ : sort | sort asString ])).
	aStream nextPut: $).

]

{ #category : #private }
LeibnizSortGraph >> privateEqualityTestWith: otherKinds and: otherSupersorts and: otherSubsorts [ 
	^ (sameKindSortsOf = otherKinds)
	  and: [ (supersortsOf = otherSupersorts)
			and: [ subsortsOf = otherSubsorts  ]]

]

{ #category : #accessing }
LeibnizSortGraph >> selectMaximalSortsFrom: aCollection [ 
	^ aCollection select: [ :sort | (supersortsOf at: sort) size = 0 ]
]

{ #category : #accessing }
LeibnizSortGraph >> size [
	^ self asSet size.

]

{ #category : #accessing }
LeibnizSortGraph >> subGraphForSorts: aSet [
	| sg |
	sg := self class new.
	aSet do: [ :sort | sg add: sort ].
	subsortsOf associationsDo:
		[ :a | (aSet includes: (a key))
					ifTrue: [ a value do:
								[ :sort | (aSet includes: sort)
												ifTrue: [ sg make: sort subsortOf: (a key) ] ] ] ].
	^ sg

]

{ #category : #accessing }
LeibnizSortGraph >> subsortsOf: aSymbol [
	| ss |
	ss := (subsortsOf at: aSymbol) deepCopy.
	^ ss inject: ss into: [ :total :sort | total union: (self subsortsOf: sort) ]
]

{ #category : #adding }
LeibnizSortGraph >> union: aSortGraph [ 
	| sg |
	sg := self copy.
	aSortGraph asSet do: [ :each | sg add: each ].
	aSortGraph withSubsortRelationsDo: [ :s1 :s2 | sg make: s1 subsortOf: s2 ].
	^ sg

]

{ #category : #viewing }
LeibnizSortGraph >> view [
	| b |
	b := RTMondrian new.
	b shape label fontName: 'Arial Unicode MS'.
	b nodes: (self asSet collect: [:s | s asString ]).
	b shape arrowedLine withShorterDistanceAttachPoint.
	self withSubsortRelationsDo:
		[ :s1 :s2 | b edges connectFrom: (s1 asString) to: (s2 asString) ].
	b layout forceWithCharge: -2000.
	b build.
	^ b view

]

{ #category : #enumerating }
LeibnizSortGraph >> withSubsortRelationsDo: aBlockClosure [ 
	supersortsOf associationsDo:
		[ :assoc | assoc value do:
					[ :sort | aBlockClosure value: (assoc key) value: sort ]]

]
