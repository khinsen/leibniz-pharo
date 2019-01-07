"
I represent a sort graph in a Leibniz context.
"
Class {
	#name : #LeibnizSortGraph,
	#superclass : #Object,
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'kinds',
		'maximalSorts',
		'directSubsortsOf',
		'subsortsOf',
		'kindsOf'
	],
	#category : #'Leibniz-Core'
}

{ #category : #'instance creation' }
LeibnizSortGraph class >> subsortRelations: aDictionary [
	^self basicNew
			initializeWithSubsortRelations: aDictionary;
			yourself

]

{ #category : #viewing }
LeibnizSortGraph >> addGraphToBuilder: aBuilder [
	aBuilder shape label
		fontName: 'Arial Unicode MS';
		color: (Color black).
	aBuilder nodes: (self asSet collect: [:s | s asString ]).
	aBuilder shape arrowedLine withShorterDistanceAttachPoint.
	self withSubsortRelationsDo:
		[ :s1 :s2 | aBuilder edges connectFrom: (s1 asString) to: (s2 asString) ].

]

{ #category : #enumerating }
LeibnizSortGraph >> allSubsortsOf: aSort [
	^ subsortsOf at: aSort

]

{ #category : #converting }
LeibnizSortGraph >> asSet [
   ^ directSubsortsOf keys asSet 

]

{ #category : #converting }
LeibnizSortGraph >> asSortGraphBuilder [
	^ LeibnizSortGraphBuilder new addSortGraph: self.

]

{ #category : #accessing }
LeibnizSortGraph >> directSubsortsOf: aSymbol [
	^ directSubsortsOf at: aSymbol.
]

{ #category : #private }
LeibnizSortGraph >> equalityTestWith: otherSubsorts [ 
	^ directSubsortsOf = otherSubsorts

]

{ #category : #viewing }
LeibnizSortGraph >> graphView [
	| b |
	b := RTMondrian new.
	self addGraphToBuilder: b.
	b layout forceWithCharge: -2000.
	b build.
	^ b view

]

{ #category : #viewing }
LeibnizSortGraph >> gtInspectorGraphViewIn: composite [
	<gtInspectorPresentationOrder: -10>
	composite roassal2
		title: 'Graph View';
		initializeView: self graphView.

]

{ #category : #viewing }
LeibnizSortGraph >> gtInspectorTreeViewIn: composite [
	<gtInspectorPresentationOrder: -11>
	composite roassal2
		title: 'Tree View';
		initializeView: self treeView.

]

{ #category : #testing }
LeibnizSortGraph >> includes: aSort [
	^ directSubsortsOf keys includes: aSort

]

{ #category : #initializing }
LeibnizSortGraph >> initializeWithSubsortRelations: subsortRelations [
	directSubsortsOf := subsortRelations.
	self setSubsortsOf.
	self setMaximalSorts.
	self setKinds.
	self beRecursivelyReadOnlyObject.

]

{ #category : #comparing }
LeibnizSortGraph >> instVarsExcludedFromEquality [
	"The only instance variable used in comparison is directSubsortsOf,
	 since all others are derived from it"
	^#(#kinds #maximalSorts #subsortsOf #kindsOf)

]

{ #category : #testing }
LeibnizSortGraph >> is: aSort directSubsortOf: anotherSort [
	^ (directSubsortsOf at: anotherSort) includes: aSort

]

{ #category : #testing }
LeibnizSortGraph >> is: aSort subsortOf: anotherSort [
	| ss |
	^ (aSort = anotherSort)
		or: [ ss := directSubsortsOf at: anotherSort.
				(ss includes: aSort)
				or: [ ss anySatisfy: [:each | self is: aSort subsortOf: each ]]]

]

{ #category : #accessing }
LeibnizSortGraph >> kindOf: aSymbol [
	^ kindsOf at: aSymbol
]

{ #category : #accessing }
LeibnizSortGraph >> kinds [
	^ kinds

]

{ #category : #accessing }
LeibnizSortGraph >> maximalSorts [
	^  maximalSorts
]

{ #category : #printing }
LeibnizSortGraph >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	aStream nextPutAll: (', ' join: (self maximalSorts collect: [ : sort | sort asString ])).
	aStream nextPut: $).

]

{ #category : #initializing }
LeibnizSortGraph >> setKinds [
	| kindCandidates kind hasCommonSorts |
	kindCandidates := maximalSorts asOrderedCollection collect: [ :sort | subsortsOf at: sort ].
	"A kind can have multiple maximal sorts. In that case, kindCandidates contains multiple sets
	 that have a non-empty intersection, and which must be merged to obtain the kind."
	kinds := Set new.
	[ kindCandidates isEmpty ] whileFalse: [ 
		kind := kindCandidates first.
		hasCommonSorts := kindCandidates allButFirst groupedBy:
									[ :c | (kind intersection: c) isNotEmpty ].
		#(true false) do: [ :b | hasCommonSorts at: b ifAbsentPut: OrderedCollection new. ].
		kind := ((hasCommonSorts at: true) inject: kind into: [ :k :c | k union: c ]).
		kinds add: (LeibnizKind sortGraph: self
		 								sorts: kind
										maximalSorts: (maximalSorts select: [ :s | kind includes: s ])).
		kindCandidates := hasCommonSorts at: false. ].

	kindsOf := Dictionary new.
	kinds do: [ :k | k asSet do: [ :s | kindsOf at: s put: k ] ].

]

{ #category : #initializing }
LeibnizSortGraph >> setMaximalSorts [
	maximalSorts := (directSubsortsOf values)
							inject: directSubsortsOf keys asSet
							into: [ :ms :ss | ms difference: ss ].
]

{ #category : #initializing }
LeibnizSortGraph >> setSubsortsOf [
	subsortsOf := Dictionary new.
	directSubsortsOf keysDo: [ :sort | self setSubsortsOfAt: sort ].
	
]

{ #category : #initializing }
LeibnizSortGraph >> setSubsortsOfAt: aSort [
	| ss |
	(subsortsOf includes: aSort) ifTrue: [ ^ self ].
	ss := (directSubsortsOf at: aSort) copy.
	ss add: aSort.
	(directSubsortsOf at: aSort) do:
		[ :sort | self setSubsortsOfAt: sort.
					 ss := ss union: (subsortsOf at: sort) ].
	subsortsOf at: aSort put: ss.
]

{ #category : #accessing }
LeibnizSortGraph >> size [
	^ self asSet size.

]

{ #category : #accessing }
LeibnizSortGraph >> subsortsOf: aSymbol [
	^ subsortsOf at: aSymbol.
]

{ #category : #viewing }
LeibnizSortGraph >> treeView [
	| b |
	b := RTMondrian new.
	self addGraphToBuilder: b.
	b layout dominanceTree
		verticallyReverse;
		horizontalGap: 20;
		verticalGap: 50.
	b build.
	^ b view

]

{ #category : #enumerating }
LeibnizSortGraph >> union: aSortGraph [ 
	| b |
	b := self asSortGraphBuilder.
	b addSortGraph: aSortGraph.
	^ b sortGraph

]

{ #category : #enumerating }
LeibnizSortGraph >> withSubsortRelationsDo: aBlockClosure [ 
	directSubsortsOf associationsDo:
		[ :assoc | assoc value do:
					[ :sort | aBlockClosure value: sort value: (assoc key) ]]

]
