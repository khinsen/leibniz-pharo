"
See ${class:name=LbSignature}$.


"
Class {
	#name : #LbOperator,
	#superclass : #Object,
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'kindArity',
		'kind',
		'ranks',
		'sortGraph',
		'name'
	],
	#category : #'Leibniz-2-Signatures'
}

{ #category : #'instance creation' }
LbOperator class >> name: anOpName argKinds: aKindArray kind: aKind [
	^ self basicNew
			initializeWithName: anOpName argKinds: aKindArray kind: aKind;
			yourself
]

{ #category : #adding }
LbOperator >> addArity: newArity withSort: newSort [
	self assertMonotonicity: [ kind includes: newSort ]
		  forArity: newArity andSort: newSort.

	ranks ifEmpty:
		[ ranks add: newArity -> newSort.
		  ^self  ].

	1 to: ranks size do:
		[	:index |
		 	| r a s |
			r := ranks at: index.
			a := r key.
			s := r value.

			a = newArity
				ifTrue:
					[ self assert: [ s = newSort ]
							 description: [ 'conflicting earlier operator definition with sort ', s asString ].
					  ^self ].

			(newArity <= a)
				ifTrue: [ self assertMonotonicity: [ sortGraph is: newSort subsortOf: s ]
									forArity: newArity andSort: newSort.
							 ranks add: newArity -> newSort beforeIndex: index.
							 ^self ].

			(a <= newArity)
				ifTrue: [ self assertMonotonicity: [ s <= newSort ]
							   forArity: newArity andSort: newSort]. ].

	ranks add: newArity -> newSort.
]

{ #category : #viewing }
LbOperator >> addGraphToBuilder: aBuilder [
	| saGraph |
	aBuilder shape label
		text: [ :r | (String streamContents:
							[ :s | self name printForArity: r key withSort: r value on: s ])];
		fontName: (LbCodeFont defaultFamily);
		color: (Color black).
	aBuilder nodes: ranks.
	aBuilder shape arrowedLine withShorterDistanceAttachPoint.
	saGraph := self minimalSubArityGraph.
	saGraph withIndicesDo:
		[ :edge :i :j |
		  edge = 1 ifTrue:
				[ aBuilder edges connectFrom: (ranks at: i) to: (ranks at: j) ] ].
]

{ #category : #inspecting }
LbOperator >> arrowInGraph [
	^ BlLineElement new
		toHead: (BlArrowheadSimpleArrow new
					border: (BlBorder paint: Color gray width: 1));
		border: (BlBorder paint: Color gray width: 1)
]

{ #category : #'error signalling' }
LbOperator >> assertMonotonicity: aBlock forArity: anArity andSort: aSort [
	self assert: aBlock
		  description: 'new rank ', anArity printString,
							' -> ', aSort asString, ' makes operator non-monotonic'.
]

{ #category : #inspecting }
LbOperator >> graphEdges [
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
LbOperator >> graphNodeForRank: anAssociation [
	| arity sort text |
	arity := anAssociation key.
	sort := anAssociation value.
	text := (String streamContents:
				[ :s | self name printForArity: arity withSort: sort on: s ] )
			asRopedText.
	text fontName: (LbCodeFont defaultFamily).
	^ BlTextElement new
		text: text;
		padding: (BlInsets all: 3);
		border: (BlBorder paint: Color gray)
]

{ #category : #inspecting }
LbOperator >> gtGraphFor: aView [
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
LbOperator >> gtInspectorNetworkViewIn: composite [
	<gtInspectorPresentationOrder: -10>
	composite roassal2
		title: 'Network View';
		initializeView: self networkView.

]

{ #category : #inspecting }
LbOperator >> gtInspectorTreeViewIn: composite [
	<gtInspectorPresentationOrder: -11>
	composite roassal2
		title: 'Tree View';
		initializeView: self treeView.

]

{ #category : #initializing }
LbOperator >> initializeWithName: anOpName argKinds: aKindArray kind: aKind [
	name := anOpName.
	kindArity := aKindArray.
	kind := aKind.
	sortGraph := kind sortGraph.
	ranks := OrderedCollection new
]

{ #category : #accessing }
LbOperator >> kind [
	^kind
]

{ #category : #accessing }
LbOperator >> kindArity [
	^kindArity
]

{ #category : #accessing }
LbOperator >> leastRankForArgSorts: aSortArray [
	| arity |
	aSortArray ifEmpty: [ self assert: ranks size equals: 1 .
								 ^ ranks first ].
	arity := LbArity sortGraph: sortGraph argSorts: aSortArray.
	^ ranks detect: [ :r | arity <= r key ]
			  ifNone: [ kindArity -> kind ].
]

{ #category : #viewing }
LbOperator >> minimalSubArityGraph [
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
	^m

]

{ #category : #accessing }
LbOperator >> name [
	^ name
]

{ #category : #viewing }
LbOperator >> networkView [
	| b |
	b := RTMondrian new.
	self addGraphToBuilder: b.
	b layout forceWithCharge: (ranks size * 1000 - 15000 min: -2000).
	b build.
	^ b view

]

{ #category : #printing }
LbOperator >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	aStream nextPutAll: name asSymbol.
	aStream nextPutAll: ': ('.
	kindArity printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: ') -> '.
	kind printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: ', '.
	ranks size printOn: aStream.
	aStream nextPutAll: ' rank(s)'.
]

{ #category : #accessing }
LbOperator >> ranksMatchingArgSorts: aSortArray [
	| arity |
	arity := LbArity sortGraph: sortGraph argSorts: aSortArray.
	^ ranks select: [ :r | arity <= r key ]
]

{ #category : #accessing }
LbOperator >> size [
	^ranks size
]

{ #category : #accessing }
LbOperator >> sortForArgSorts: aSortArray [
	^ (self leastRankForArgSorts: aSortArray) value
]

{ #category : #accessing }
LbOperator >> sortGraph [
	^ sortGraph
]

{ #category : #viewing }
LbOperator >> subArityGraph [
	^ Array2D new: ranks size tabulate:
		[ :i :j |
			(i ~= j and: [ (ranks at: i) key <= (ranks at: j) key ])
				ifTrue: [ 1 ] ifFalse: [ 0 ] ]
]

{ #category : #inspecting }
LbOperator >> title [
	^String streamContents:
		[ :stream |
			self name printForArity: kindArity on: stream.
			stream nextPutAll: ' : '.
			self kind printAsLeibnizSyntaxOn: stream. ]
]

{ #category : #viewing }
LbOperator >> treeView [
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
LbOperator >> withRanksDo: aBlock [
	ranks do: [ :r |  aBlock value: r key value: r value ]
]
