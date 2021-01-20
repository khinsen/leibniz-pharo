Class {
	#name : #LbDependentSortGraph,
	#superclass : #Object,
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'context',
		'sortSort',
		'sortOps',
		'directSubsorts',
		'maximalSorts',
		'subsorts',
		'kinds'
	],
	#category : #'Leibniz-7-DependentSorts'
}

{ #category : #'instance creation' }
LbDependentSortGraph class >> sortContext: aContext directSubsorts: aSubsortDictionary subsortAxioms: anAxiomDictionary [
	^ self basicNew
		initializeWithSortContext: aContext
		directSubsorts: aSubsortDictionary
		subsortAxioms: anAxiomDictionary;
		yourself
]

{ #category : #copying }
LbDependentSortGraph >> copy [
	^ self
]

{ #category : #copying }
LbDependentSortGraph >> deepCopy [
	^ self
]

{ #category : #lookup }
LbDependentSortGraph >> directSupersortsOf: aSortTerm [
	| supersorts |
	supersorts := Set new.
	context axioms subsortAxioms do: [ :each |
		(each supersortOf: aSortTerm)
			ifNotNil: [ :term | supersorts add: (self sortFor: term) ] ].
	^ supersorts
]

{ #category : #accessing }
LbDependentSortGraph >> includes: aSortTerm [
	self flag: #todo.
	^ true.
]

{ #category : #initialization }
LbDependentSortGraph >> initializeKinds [
	| kindCandidates |
	kindCandidates := maximalSorts asOrderedCollection
		collect: [ :sort | subsorts at: sort ].
	"A kind can have multiple maximal sorts. In that case, kindCandidates
	 contains multiple sets that have a non-empty intersection, and which
	 must be merged to obtain the kind."
	kinds := Set new.
	[ kindCandidates isEmpty ] whileFalse: [
		| kind hasCommonSorts |
		kind := kindCandidates first.
		hasCommonSorts :=
			kindCandidates allButFirst groupedBy: [ :c |
				(kind intersection: c) isNotEmpty ].
		#(true false) do: [ :b |
			hasCommonSorts at: b ifAbsentPut: OrderedCollection new. ].
		kind := ((hasCommonSorts at: true) inject: kind into: [ :k :c | k union: c ]).
		kinds add: (LbKind
						sortGraph: self
						sorts: kind
						maximalSorts: (maximalSorts select: [ :s |
											kind includes: s ])).
		kindCandidates := hasCommonSorts at: false. ].

"	kindsOf := Dictionary new.
	kinds do: [ :k | k asSet do: [ :s | kindsOf at: s name put: k ] ]"
]

{ #category : #initialization }
LbDependentSortGraph >> initializeMaximalSorts [
	maximalSorts :=
		(directSubsorts values)
			inject: sortOps asSet
			into: [ :ms :ss | ms difference: ss ]
]

{ #category : #initialization }
LbDependentSortGraph >> initializeSubsorts: aSubsortDictionary [
	directSubsorts := aSubsortDictionary.
	subsorts := Dictionary new.
	directSubsorts keysDo: [ :sort |
		self initializeSubsortsFor: sort ]	
]

{ #category : #initialization }
LbDependentSortGraph >> initializeSubsortsFor: aSort [
	| dss ss |
	(subsorts includes: aSort) ifTrue: [ ^ self ].
	dss := directSubsorts at: aSort.
	ss := dss copy.
	ss add: aSort.
	dss do: [ :sort |
		self initializeSubsortsFor: sort.
		ss := ss union: (subsorts at: sort) ].
	subsorts at: aSort put: ss
]

{ #category : #initialization }
LbDependentSortGraph >> initializeWithSortContext: anLbContext directSubsorts: aSubsortDictionary subsortAxioms: anAxiomDictionary [
	context := anLbContext.
	sortOps := aSubsortDictionary keys asSet.
	sortSort := context sortGraph sortNamed: #sort.
	self initializeSubsorts: aSubsortDictionary.
	self initializeMaximalSorts.
	self initializeKinds.
	self beRecursivelyReadOnlyObject
]

{ #category : #accessing }
LbDependentSortGraph >> normalizedSortFor: aSortTerm [
	self assert: aSortTerm sort <= sortSort.
	^ LbDependentSort sortGraph: self term: (context reduce: aSortTerm)
]

{ #category : #lookup }
LbDependentSortGraph >> parseSort: aString [
	^ self sortFor: (context parseTerm: aString)
]

{ #category : #accessing }
LbDependentSortGraph >> sortContext [
	^ context
]

{ #category : #accessing }
LbDependentSortGraph >> sortFor: aSortTerm [
	self assert: aSortTerm sort <= sortSort.
	^ LbDependentSort sortGraph: self term: aSortTerm
]

{ #category : #lookup }
LbDependentSortGraph >> sortNamed: aSymbol [
	self flag: #legacy.
	^ self parseSort: aSymbol
]
