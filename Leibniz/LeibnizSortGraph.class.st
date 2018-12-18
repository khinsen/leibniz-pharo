"
I represent a sort graph in a Leibniz context.
"
Class {
	#name : #LeibnizSortGraph,
	#superclass : #Object,
	#instVars : [
		'subsort',
		'supersort',
		'kind'
	],
	#category : #'Leibniz-Core'
}

{ #category : #comparing }
LeibnizSortGraph >> = aSortGraph [
	^ aSortGraph privateEqualityTestWith: kind and: supersort and: subsort
]

{ #category : #adding }
LeibnizSortGraph >> add: aSymbol [
   (self includes: aSymbol)
     ifFalse: [ kind at: aSymbol put: (Set with: aSymbol).
                supersort at: aSymbol put: Set new.
                subsort at: aSymbol put: Set new. ].
   ^ aSymbol

]

{ #category : #converting }
LeibnizSortGraph >> asSet [
   ^ kind keys asSet 

]

{ #category : #accessing }
LeibnizSortGraph >> directSubsortsOf: aSymbol [
	^ subsort at: aSymbol.
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
	^ kind hash
	
]

{ #category : #testing }
LeibnizSortGraph >> includes: aSort [
	^ kind keys includes: aSort

]

{ #category : #initializing }
LeibnizSortGraph >> initialize [
   kind := Dictionary new.
	subsort := Dictionary new.
	supersort := Dictionary new
]

{ #category : #testing }
LeibnizSortGraph >> is: aSort subsortOf: anotherSort [
	| ss |
	^ (aSort = anotherSort)
		or: [ ss := subsort at: anotherSort.
				(ss includes: aSort)
				or: [ ss anySatisfy: [:each | self is: aSort subsortOf: each ]]]

]

{ #category : #accessing }
LeibnizSortGraph >> kindOf: aSymbol [
	^ kind at: aSymbol
]

{ #category : #accessing }
LeibnizSortGraph >> kinds [
	| k |
	k := Set new.
	kind values asSet do:
		[ :sorts | k add: (self subGraphWithSorts: sorts) ].
	^ k
]

{ #category : #adding }
LeibnizSortGraph >> make: aSort subsortOf: anotherSort [
	| new_kind |
	(aSort = anotherSort) ifTrue: [ ^ self ].
	(self is: anotherSort subsortOf: aSort)
		ifTrue: [ self error: 'cycle in subsort relation: ',
			                   (anotherSort printString), '<', (aSort printString ) ].
	new_kind := (kind at: aSort) union: (kind at: anotherSort).
	new_kind do: [ :sort | kind at: sort put: new_kind].
	(supersort at: aSort) add: anotherSort.
	(subsort at: anotherSort) add: aSort.
]

{ #category : #accessing }
LeibnizSortGraph >> maximalSorts: aCollection [ 
	^ aCollection select: [ :sort | (supersort at: sort) size = 0 ]
]

{ #category : #copying }
LeibnizSortGraph >> postCopy [
	super postCopy.
	kind := kind deepCopy.
	supersort := supersort deepCopy.
	subsort := subsort deepCopy.
]

{ #category : #private }
LeibnizSortGraph >> privateEqualityTestWith: otherKinds and: otherSupersorts and: otherSubsorts [ 
	^ (kind = otherKinds)
	  and: [ (supersort = otherSupersorts)
			and: [ subsort = otherSubsorts  ]]

]

{ #category : #accessing }
LeibnizSortGraph >> size [
	^ self asSet size.

]

{ #category : #accessing }
LeibnizSortGraph >> subGraphWithSorts: aSet [
	| sg |
	sg := self class new.
	aSet do: [ :sort | sg add: sort ].
	subsort associationsDo:
		[ :a | (aSet includes: (a key))
					ifTrue: [ a value do:
								[ :sort | (aSet includes: sort)
												ifTrue: [ sg make: (a key) subsortOf: sort ] ] ] ].
	^ sg

]

{ #category : #accessing }
LeibnizSortGraph >> subsortsOf: aSymbol [
	| ss |
	ss := (subsort at: aSymbol) deepCopy.
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
	supersort associationsDo:
		[ :assoc | assoc value do:
					[ :sort | aBlockClosure value: (assoc key) value: sort ]]

]
