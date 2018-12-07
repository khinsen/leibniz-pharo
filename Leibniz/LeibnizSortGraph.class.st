"
I represent a sort graph in a Leibniz context.
"
Class {
	#name : #LeibnizSortGraph,
	#superclass : #Object,
	#instVars : [
		'kinds',
		'supersorts',
		'subsorts'
	],
	#category : 'Leibniz'
}

{ #category : #comparing }
LeibnizSortGraph >> = aSortGraph [
	^ aSortGraph privateEqualityTestWith: kinds and: supersorts and: subsorts
]

{ #category : #adding }
LeibnizSortGraph >> add: aSymbol [
   (self includes: aSymbol)
     ifFalse: [ kinds at: aSymbol put: (Set with: aSymbol).
                supersorts at: aSymbol put: Set new.
                subsorts at: aSymbol put: Set new. ].
   ^ aSymbol

]

{ #category : #converting }
LeibnizSortGraph >> asSet [
   ^ kinds keys asSet 

]

{ #category : #accessing }
LeibnizSortGraph >> directSubsortsOf: aSymbol [
	^ subsorts at: aSymbol.
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
	^ kinds hash
	
]

{ #category : #testing }
LeibnizSortGraph >> includes: aSort [
	^ kinds keys includes: aSort

]

{ #category : #initializing }
LeibnizSortGraph >> initialize [
   kinds := Dictionary new.
	subsorts := Dictionary new.
	supersorts := Dictionary new
]

{ #category : #testing }
LeibnizSortGraph >> is: aSort subsortOf: anotherSort [
	| ss |
	^ (aSort = anotherSort)
		or: [ ss := subsorts at: anotherSort.
				(ss includes: aSort)
				or: [ ss anySatisfy: [:each | self is: aSort subsortOf: each ]]]

]

{ #category : #accessing }
LeibnizSortGraph >> kindOf: aSymbol [
	^ kinds at: aSymbol
]

{ #category : #adding }
LeibnizSortGraph >> make: aSort subsortOf: anotherSort [
	| new_kind |
	(aSort = anotherSort) ifTrue: [ ^ self ].
	(self is: anotherSort subsortOf: aSort)
		ifTrue: [ self error: 'cycle in subsort relation: ',
			                   (anotherSort printString), '<', (aSort printString ) ].
	new_kind := (kinds at: aSort) union: (kinds at: anotherSort).
	new_kind do: [ :sort | kinds at: sort put: new_kind].
	(supersorts at: aSort) add: anotherSort.
	(subsorts at: anotherSort) add: aSort.
]

{ #category : #accessing }
LeibnizSortGraph >> maximalSorts: aCollection [ 
	^ aCollection select: [ :sort | (supersorts at: sort) size = 0 ]
]

{ #category : #copying }
LeibnizSortGraph >> postCopy [
	super postCopy.
	kinds := kinds deepCopy.
	supersorts := supersorts deepCopy.
	subsorts := subsorts deepCopy.
]

{ #category : #private }
LeibnizSortGraph >> privateEqualityTestWith: otherKinds and: otherSupersorts and: otherSubsorts [ 
	^ (kinds = otherKinds)
	  and: [ (supersorts = otherSupersorts)
			and: [ subsorts = otherSubsorts  ]]

]

{ #category : #accessing }
LeibnizSortGraph >> size [
	^ self asSet size.

]

{ #category : #accessing }
LeibnizSortGraph >> subsortsOf: aSymbol [
	| ss |
	ss := (subsorts at: aSymbol) deepCopy.
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
	supersorts associationsDo:
		[ :assoc | assoc value do:
					[ :sort | aBlockClosure value: (assoc key) value: sort ]]

]
