Class {
	#name : #LzOperator,
	#superclass : #Object,
	#traits : 'TLzEquality + TLzPrintable',
	#classTraits : 'TLzEquality classTrait + TLzPrintable classTrait',
	#instVars : [
		'kind',
		'kindArity',
		'opName',
		'sortGraph',
		'ranks'
	],
	#category : #'Leibniz2-Signatures'
}

{ #category : #defining }
LzOperator >> addArity: newArity sort: newSort [
	self
		assertMonotonicity: [ kind includes: newSort ]
		arity: newArity sort: newSort.

	ranks ifEmpty: [
		ranks add: newArity -> newSort.
		^ self  ].

	1 to: ranks size do: [ :index |
		| r a s |
		r := ranks at: index.
		a := r key.
		s := r value.

		a = newArity ifTrue: [
			self
				assert: s = newSort
				description: 'conflicting earlier operator definition with sort ', s asString.
			^ self ].

		(newArity <= a) ifTrue: [
			"First case: all sorts conforming to newArity also conform to a.
			 newArity must then be inserted before a."
			self
				assertMonotonicity: [ newSort <= s ]
				arity: newArity sort: newSort.
			ranks add: newArity -> newSort beforeIndex: index.
			^ self ].

		(a <= newArity) ifTrue: [
			"Second case: all sorts conforming to a also conform to newArity.
			newArity must be inserted after a, but perhaps not immediately.
			Continue the search."
			self
				assertMonotonicity: [ s <= newSort ]
				arity: newArity sort: newSort ] ].

	ranks add: newArity -> newSort
]

{ #category : #private }
LzOperator >> assertMonotonicity: aBlock arity: anArity sort: aSort [
	self
		assert: aBlock
		description: 'declaration ',
		  	(String streamContents: [ :s |
		  		opName printForArity: anArity withSort: aSort on: s ]),
		  	' makes operator non-monotonic'.
]

{ #category : #accessing }
LzOperator >> graphEdges [
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
LzOperator >> graphNodeForRank: anAssociation [
	| arity sort text |
	arity := anAssociation key.
	sort := anAssociation value.
	text := (String streamContents: [ :s |
		self opName printForArity: arity withSort: sort on: s ] )
		asRopedText.
	text fontName: (LbCodeFont defaultFamily).
	^ BlTextElement new
		text: text;
		padding: (BlInsets all: 3);
		border: (BlBorder paint: Color gray)
]

{ #category : #inspecting }
LzOperator >> gtGraphFor: aView [
	<gtView>
	^ aView mondrian
		title: 'Graph';
		priority: 1;
		painting: [ :view | 
			| edges |
			view nodes
				shape: [ :r | self graphNodeForRank: r ];
				with: ranks.
			view edges
				shape: [ :x | LzGraphicsElements graphArrow ];
				fromCenterTop;
				toCenterBottom;
				connect: (self graphEdges)
					from: #key
					to: #value.
			view layout
				custom: (GtGradVerticalDominanceTreeLayout new reverse: true) ]
]

{ #category : #inspecting }
LzOperator >> gtRanksFor: aView [
	<gtView>
	ranks ifEmpty: [ ^ aView empty ].
	^ aView columnedList
		title: 'Ranks';
		priority: 0;
		items: [ ranks ];
		column: 'Variables' lzCode: [ :each |
			(String streamContents: [ :s |
				each key printVariablesAsLeibnizSyntaxOn: s ] )
			asRopedText ];
		column: 'Arity' lzCode: [ :each |
			(String streamContents: [ :s |
				self opName printForArity: each key on: s ] )
			asRopedText ];
		column: 'Sort' lzCode: [ :each |
			each value asLeibnizSyntaxString asRopedText ];
		yourself
]

{ #category : #accessing }
LzOperator >> initialize [
	ranks := OrderedCollection new
]

{ #category : #accessing }
LzOperator >> kind [
	^ kind
]

{ #category : #accessing }
LzOperator >> kind: aSort [
	kind := aSort
]

{ #category : #accessing }
LzOperator >> kindArity [
	^ kindArity
]

{ #category : #accessing }
LzOperator >> kindArity: anArity [
	kindArity := anArity
]

{ #category : #lookup }
LzOperator >> matchingRanksGeneratorFor: anArity [
	^ Generator on: [ :generator |
		ranks do: [ :each |
			| match |
			match := LzBindings new
						sortGraph: sortGraph.
			each key with: anArity do: [ :sortPattern :sort |
				match combineWith: (sortPattern matchWithSupersortsOf: sort) ].
			match ifSuccess: [
				generator yield: (each key collect: [ :s | s substitute: match ])
									-> (each value substituteAndReduce: match) ] ] ]
]

{ #category : #inspecting }
LzOperator >> minimalSubArityGraph [
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
LzOperator >> opName [
	^ opName
]

{ #category : #accessing }
LzOperator >> opName: anOpName [
	opName := anOpName
]

{ #category : #printing }
LzOperator >> printAsLeibnizSyntaxOn: aStream [
	opName printForArity:  kindArity on: aStream
]

{ #category : #lookup }
LzOperator >> ranksMatching: anArity [
	^ (self matchingRanksGeneratorFor: anArity) contents
]

{ #category : #accessing }
LzOperator >> referenceNames [
	^ #(sortGraph)
]

{ #category : #accessing }
LzOperator >> referenceSlots [
	^ #(sortGraph kind kindArity)
]

{ #category : #accessing }
LzOperator >> size [
	^ ranks size
]

{ #category : #lookup }
LzOperator >> sortForArity: anArity [
	| matches |
	matches := self matchingRanksGeneratorFor: anArity.
	matches atEnd ifTrue: [
		self error: 'No rank matching arity ',
				anArity asLeibnizSyntaxString ].
	^ matches next value
]

{ #category : #accessing }
LzOperator >> sortGraph [
	^ sortGraph
]

{ #category : #accessing }
LzOperator >> sortGraph: aSortGraph [
	sortGraph := aSortGraph
]

{ #category : #inspecting }
LzOperator >> subArityGraph [
	^ Array2D new: ranks size tabulate:
		[ :i :j |
			(i ~= j and: [ (ranks at: i) key <= (ranks at: j) key ])
				ifTrue: [ 1 ] ifFalse: [ 0 ] ]
]

{ #category : #accessing }
LzOperator >> valueSlots [
	^ #(opName ranks)
]
