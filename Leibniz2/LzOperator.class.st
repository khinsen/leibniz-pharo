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
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #defining }
LzOperator >> addArity: newArity sort: newSort [
	self flag: #todo.
	"self assertMonotonicity: [ kind includes: newSortPattern ]
		  forArity: newArity andSortPattern: newSortPattern."

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
			self flag: #todo.
			"self
	 			assertMonotonicity: [ newSort <= s ]
				 forArity: newArity andSortPattern: newSort."
			ranks add: newArity -> newSort beforeIndex: index.
			^ self ].

		(a <= newArity) ifTrue: [
			"Second case: all sorts conforming to a also conform to newArity.
			newArity must be inserted after a, but perhaps not immediately.
			Continue the search."
			self flag: #todo.
			"self
				assertMonotonicity: [ s <= newSort ]
				forArity: newArity andSortPattern: newSort" ] ].

	ranks add: newArity -> newSort
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
				each key printVariablesOn: s ] )
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
	| matches |
	matches := OrderedCollection new.
	ranks do: [ :each |
		self flag: #todo. "Implement full version"
		anArity <= each key ifTrue: [ matches add: each ].
		"| match |
		match := LbVariables new.
		each key with: anArity do: [ :patternArg :valueArg |
			| submatches |
			submatches := patternArg matchAllSupersortsOf: valueArg.
			submatches
				ifEmpty: [ match failUnless: valueArg isSubsortOf: patternArg ]
				ifNotEmpty: [
					submatches size > 1
						ifTrue: [ self error: 'Multiple matches not yet implemented' ].
					match combineWith: submatches anyOne ] ].
		match ifSuccess: [
			matches add: (each key collect: [ :s | s substitute: match ])
							-> (each value substituteAndReduce: match) ]"
	].
	^ matches
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
	matches := self ranksMatching: anArity.
	matches ifEmpty: [ self error: 'No rank matching arity ', anArity asLeibnizSyntaxString ].
	^ matches first value
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
