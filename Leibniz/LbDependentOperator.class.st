Class {
	#name : #LbDependentOperator,
	#superclass : #Object,
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'name',
		'sortGraph',
		'ranks',
		'kindFamily',
		'kindFamilyArity'
	],
	#category : #'Leibniz-7-DependentSorts'
}

{ #category : #'instance creation' }
LbDependentOperator class >> name: anOpName kindFamilyArity: aKindFamilyArray kindFamily: aKindFamily [
	^ self basicNew
			initializeWithName: anOpName
			kindFamilyArity: aKindFamilyArray
			kindFamily: aKindFamily;
			yourself
]

{ #category : #adding }
LbDependentOperator >> addArity: newArity withSort: newSortPattern [
	self
		assertMonotonicity: [ kindFamily = newSortPattern kindFamily ]
		forArity: newArity andSortPattern: newSortPattern.

	ranks ifEmpty:
		[ ranks add: newArity -> newSortPattern.
		  ^ self  ].

	1 to: ranks size do: [ :index |
		| r a s |
		r := ranks at: index.
		a := r key.
		s := r value.

		a = newArity ifTrue: [
			self
				assert: [ s = newSortPattern ]
				description: [ 'conflicting earlier operator definition with sort ', s asLeibnizSyntaxString ].
			^ self ].

		(newArity <= a) ifTrue: [
			self
				assertMonotonicity: [ newSortPattern <= s ]
				forArity: newArity andSortPattern: newSortPattern.
			ranks add: newArity -> newSortPattern beforeIndex: index.
			^ self ].

		(a <= newArity) ifTrue: [
			self
				assertMonotonicity: [ s <= newSortPattern ]
				forArity: newArity andSortPattern: newSortPattern]. ].

	ranks add: newArity -> newSortPattern
]

{ #category : #private }
LbDependentOperator >> assertMonotonicity: aBlock forArity: anArity andSortPattern: aSortPattern [
	self
		assert: aBlock
		description: 'declaration ',
		  	(String streamContents: [ :s |
		  		name printForArity: anArity withSort: aSortPattern on: s ]),
		  	' makes operator non-monotonic'.
]

{ #category : #inspecting }
LbDependentOperator >> graphEdges [
	| saGraph edges |
	saGraph := self minimalSubArityGraph.
	edges := OrderedCollection new.
	saGraph withIndicesDo:
		[ :edge :i :j |
		  edge = 1 ifTrue:
				[ edges add: (ranks at: i) -> (ranks at: j) ] ].
	^ edges
]

{ #category : #inspecting }
LbDependentOperator >> graphNodeForRank: anAssociation [
	| arity sort text |
	arity := anAssociation key.
	sort := anAssociation value.
	text := (String streamContents: [ :s |
		self name printForArity: arity withSort: sort on: s ] )
		asRopedText.
	text fontName: (LbCodeFont defaultFamily).
	^ BlTextElement new
		text: text;
		padding: (BlInsets all: 3);
		border: (BlBorder paint: Color gray)
]

{ #category : #inspecting }
LbDependentOperator >> gtGraphFor: aView [
	<gtView>
	^ aView mondrian
		title: 'Graph';
		priority: 0;
		painting: [ :view | 
			| edges |
			view nodes
				shape: [ :r | self graphNodeForRank: r ];
				with: ranks.
			view edges
				shape: [ :x | self arrowInGraph ];
				fromCenterTop;
				toCenterBottom;
				connect: (self graphEdges)
					from: #key
					to: #value.
			view layout
				custom: (GtGradVerticalDominanceTreeLayout new reverse: true) ]
]

{ #category : #inspecting }
LbDependentOperator >> gtRanksFor: aView [
	<gtView>
	ranks ifEmpty: [ ^ aView empty ].
	^ aView list
		title: 'Ranks';
		priority: 0;
		items: [ ranks associations ];
		itemLbCode: [ :each |
			(String streamContents:
				[ :s | self name printForArity: each key withSort: each value on: s ] )
			asRopedText ];
		yourself
]

{ #category : #initialization }
LbDependentOperator >> initializeWithName: anOpName kindFamilyArity: aKindFamilyArity kindFamily: aKindFamily [
	name := anOpName.
	kindFamilyArity := aKindFamilyArity.
	kindFamily := aKindFamily.
	sortGraph := kindFamily sortGraph.
	ranks := OrderedCollection new.
]

{ #category : #accessing }
LbDependentOperator >> kindPattern [
	^ kindFamily
]

{ #category : #accessing }
LbDependentOperator >> kindPatternArity [
	^ kindFamilyArity
]

{ #category : #inspecting }
LbDependentOperator >> minimalSubArityGraph [
	"Answer the adjacency matrix for the minimal sub-arity graph that has the
	same connected components as the full one. This minimal graph is constructed
	from the full one by removing all edges that are equivalent to multi-edge
	paths."
	| m mPower |
	m := self subArityGraph.
	mPower := m.
	ranks size - 2 timesRepeat:
		[ mPower := mPower +* m.
		  m := m with: mPower collect: [ :a :b | b > 0 ifTrue: [ 0 ] ifFalse: [ a ] ] ].
	"Since the graph is acyclic, the next power must be all zeros."
	mPower := mPower +* m.
	self assert: mPower equals: (Array2D zeros: ranks size).
	^ m
]

{ #category : #accessing }
LbDependentOperator >> name [
	^ name
]

{ #category : #printing }
LbDependentOperator >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	aStream nextPutAll: name asSymbol.
	aStream nextPutAll: ': ('.
	kindFamilyArity printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: ') -> '.
	kindFamily printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: ', '.
	ranks size printOn: aStream.
	aStream nextPutAll: ' rank(s)'
]

{ #category : #lookup }
LbDependentOperator >> ranksMatchingArgSortPatterns: aSortPatternArray [
	| matches |
	matches := OrderedCollection new.
	ranks associationsDo: [ :each |
		| match |
		match := LbVariables new.
		each key with: aSortPatternArray do: [ :patternArg :valueArg |
			| submatches |
			submatches := patternArg matchAllSupersortsOf: valueArg.
			submatches
				ifEmpty: [ match makeNull ]
				ifNotEmpty: [
					submatches size > 1
						ifTrue: [ self error: 'Multiple matches not yet implemented'].
					match combineWith: submatches anyOne ] ].
		match ifNotNull: [
			matches add: (each key collect: [ :s | s substitute: match ])
							-> (each value substituteAndReduce: match) ] ].
	^ matches
]

{ #category : #accessing }
LbDependentOperator >> size [
	^ ranks size
]

{ #category : #lookup }
LbDependentOperator >> sortPatternForArgSortPatterns: aSortPatternArray [
	| matches |
	matches := self ranksMatchingArgSortPatterns: aSortPatternArray.
	self assert: matches size equals: 1.
	^ matches first value
]

{ #category : #inspecting }
LbDependentOperator >> subArityGraph [
	^ Array2D new: ranks size tabulate:
		[ :i :j |
			(i ~= j and: [ (ranks at: i) key <= (ranks at: j) key ])
				ifTrue: [ 1 ] ifFalse: [ 0 ] ]
]
