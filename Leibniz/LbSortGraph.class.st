"
!!Sorts, sort graphs, and kinds

Sorts are names given to sets of values. They are similar to types in programming languages. In the Pharo implementation, sorts are plain symbols.

A sort can be declared to be a subsort of another sort, meaning that its values are in a subset of the set rof values epresented by the supersort. A graph formed by subsort relations is called a sort graph.

The connected components of a sort graph are called kinds. Sorts that are in different kinds are completely unrelated.

As an example, let's look at the sort graph of the built-in context 'real-numbers':
[[[
builtins := LeibnizLibrary uniqueInstance builtins.
(builtins contextNamed: 'real-numbers') sortGraph
]]]

It consists of two kinds, one of which contains a single sort, ==#boolean==. The second kind groups together all the number sorts built into Leibniz. The suffix ==.nz== stands for non-zero, ==.p== stands for positive, and ==.nn== stands for non-negative.

Sort graphs are immutable objects. They are constructed by a ${class:name=LbSortGraphBuilder}$.

"
Class {
	#name : #LbSortGraph,
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
	#category : #'Leibniz-1-SortGraphs'
}

{ #category : #'instance creation' }
LbSortGraph class >> fromSubsortRelations: aDictionary [
	^self basicNew
			initializeWithSubsortRelations: aDictionary;
			yourself

]

{ #category : #converting }
LbSortGraph >> asSet [
   ^ directSubsortsOf keys asSet 

]

{ #category : #converting }
LbSortGraph >> asSortGraphBuilder [
	^ LbSortGraphBuilder new addSortGraph: self.

]

{ #category : #copying }
LbSortGraph >> copy [
	^self

]

{ #category : #copying }
LbSortGraph >> deepCopy [
	^self

]

{ #category : #accessing }
LbSortGraph >> directSubsortsOf: aSymbol [
	^ directSubsortsOf at: aSymbol.
]

{ #category : #private }
LbSortGraph >> equalityTestWith: otherSubsorts [ 
	^ directSubsortsOf = otherSubsorts

]

{ #category : #accessing }
LbSortGraph >> graphEdgesForSubset: aSet [
	| edges |
	edges := OrderedCollection new.
	self withSubsortRelationsDo:
		[ :s1 :s2 | ((aSet includes: s1) and: [aSet includes: s2])
						ifTrue: [ edges add: s1 asString -> s2 asString ] ].
	^ edges
]

{ #category : #viewing }
LbSortGraph >> grayArrow [
	^ BlLineElement new
		toHead: (BlArrowheadSimpleArrow new
					border: (BlBorder paint: Color gray width: 1));
		border: (BlBorder paint: Color gray width: 1)
]

{ #category : #inspecting }
LbSortGraph >> gtTreeViewFor: aView [
	<gtView>
	^ aView mondrian
		title: 'Tree view';
		priority: 0;
		painting: [ :view | 
			| edges |
			view nodes
				shape: [ :x | self nodeForSort: x ];
				with: self asSet.
			view edges
				shape: [ :x | self grayArrow ];
				fromCenterTop;
				toCenterBottom;
				connect: (self graphEdgesForSubset: self asSet)
					from: #key
					to: #value.
			view layout
				custom: (GtGradVerticalDominanceTreeLayout new reverse: true) ]
]

{ #category : #initializing }
LbSortGraph >> initializeKinds [
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
		kinds add: (LbKind sortGraph: self
		 								sorts: kind
										maximalSorts: (maximalSorts select: [ :s | kind includes: s ])).
		kindCandidates := hasCommonSorts at: false. ].

	kindsOf := Dictionary new.
	kinds do: [ :k | k asSet do: [ :s | kindsOf at: s put: k ] ].

]

{ #category : #initializing }
LbSortGraph >> initializeMaximalSorts [
	maximalSorts := (directSubsortsOf values)
							inject: directSubsortsOf keys asSet
							into: [ :ms :ss | ms difference: ss ].
]

{ #category : #initializing }
LbSortGraph >> initializeSubsortsOf [
	subsortsOf := Dictionary new.
	directSubsortsOf keysDo: [ :sort | self initializeSubsortsOfAt: sort ].
	
]

{ #category : #initializing }
LbSortGraph >> initializeSubsortsOfAt: aSort [
	| ss |
	(subsortsOf includes: aSort) ifTrue: [ ^ self ].
	ss := (directSubsortsOf at: aSort) copy.
	ss add: aSort.
	(directSubsortsOf at: aSort) do:
		[ :sort | self initializeSubsortsOfAt: sort.
					 ss := ss union: (subsortsOf at: sort) ].
	subsortsOf at: aSort put: ss.
]

{ #category : #initializing }
LbSortGraph >> initializeWithSubsortRelations: subsortRelations [
	directSubsortsOf := subsortRelations.
	self initializeSubsortsOf.
	self initializeMaximalSorts.
	self initializeKinds.
	self beRecursivelyReadOnlyObject.

]

{ #category : #comparing }
LbSortGraph >> instVarsExcludedFromEquality [
	"The only instance variable used in comparison is directSubsortsOf,
	 since all others are derived from it"
	^#(#kinds #maximalSorts #subsortsOf #kindsOf)

]

{ #category : #private }
LbSortGraph >> is: aSort subsortOf: anotherSort [
	| ss |
	^ (aSort = anotherSort)
		or: [ ss := directSubsortsOf at: anotherSort.
				(ss includes: aSort)
				or: [ ss anySatisfy: [:each | self is: aSort subsortOf: each ]]]

]

{ #category : #private }
LbSortGraph >> kindOf: aSymbol [
	^ kindsOf at: aSymbol
]

{ #category : #accessing }
LbSortGraph >> kinds [
	^ kinds

]

{ #category : #accessing }
LbSortGraph >> maximalSorts [
	^  maximalSorts
]

{ #category : #viewing }
LbSortGraph >> nodeForSort: aSort [
	^ BlTextElement new
		text: aSort asString asRopedText;
		padding:
			(BlInsets
				top: 5
				right: 5
				bottom: 5
				left: 5)
]

{ #category : #printing }
LbSortGraph >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	aStream nextPutAll: (', ' join: (self maximalSorts collect: [ : sort | sort asString ])).
	aStream nextPut: $).

]

{ #category : #accessing }
LbSortGraph >> size [
	^ self asSet size.

]

{ #category : #accessing }
LbSortGraph >> sortNamed: aSymbol [
	self assert: (directSubsortsOf includesKey: aSymbol) description: 'No sort named ', aSymbol.
	^ LbSort named: aSymbol in: self
]

{ #category : #accessing }
LbSortGraph >> subsortsOf: aSymbol [
	^ subsortsOf at: aSymbol.
]

{ #category : #inspecting }
LbSortGraph >> title [
	^'sort graph'

]

{ #category : #enumerating }
LbSortGraph >> union: aSortGraph [ 
	| b |
	b := self asSortGraphBuilder.
	b addSortGraph: aSortGraph.
	^ b sortGraph

]

{ #category : #enumerating }
LbSortGraph >> withSubsortRelationsDo: aBlockClosure [ 
	directSubsortsOf associationsDo:
		[ :assoc | assoc value do:
					[ :sort | aBlockClosure value: sort value: (assoc key) ]]

]
