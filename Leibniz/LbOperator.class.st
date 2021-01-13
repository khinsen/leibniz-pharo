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
		'name',
		'origins'
	],
	#category : #'Leibniz-2-Signatures'
}

{ #category : #'instance creation' }
LbOperator class >> name: anOpName argKinds: aKindArray kind: aKind origins: anLbOrigins [
	^ self basicNew
			initializeWithName: anOpName argKinds: aKindArray kind: aKind origins: anLbOrigins;
			yourself
]

{ #category : #adding }
LbOperator >> addArity: newArity withSort: newSort origins: anLbOrigins [
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
				ifTrue: [ self assertMonotonicity: [ newSort <= s ]
							   forArity: newArity andSort: newSort.
						  ranks add: newArity -> newSort beforeIndex: index.
						  ^ self ].

			(a <= newArity)
				ifTrue: [ self assertMonotonicity: [ s <= newSort ]
							   forArity: newArity andSort: newSort]. ].

	ranks add: newArity -> newSort.
	origins merge: anLbOrigins
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
		  description: 'declaration ',
		  	(String streamContents: [ :s |
		  		name printForArity: anArity withSort: aSort on: s ]),
		  	' makes operator non-monotonic'.
]

{ #category : #accessing }
LbOperator >> declarations [
	^ (ranks sorted: [ :rankA :rankB | rankA key sortBefore: rankB key] )
		collect: [ :each | (self name printStringForArity: each key), ' : ', each value asLeibnizSyntaxString ]
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

{ #category : #accessing }
LbOperator >> gtDeclarationsFor: aView [
	<gtView>
	| addEmptyChildList |
	addEmptyChildList :=
		[ :aList | aList collect: [ :each | {each. #()} ]].
	^ aView list
		title: 'Declarations' translated;
		priority: 2;
		items: [ self declarations ];
		itemLbCode: [ :each | each ];
		yourself
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

{ #category : #accessing }
LbOperator >> gtOriginsFor: aView [
	<gtView>
	origins ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Origins';
		priority: 3;
		object: [ origins ];
		view: #gtItemsFor:;
		yourself
]

{ #category : #initializing }
LbOperator >> initializeWithName: anOpName argKinds: aKindArray kind: aKind origins: anLbOrigins [
	name := anOpName.
	kindArity := aKindArray.
	kind := aKind.
	sortGraph := kind sortGraph.
	ranks := OrderedCollection new.
	origins := anLbOrigins
]

{ #category : #accessing }
LbOperator >> kind [
	^kind
]

{ #category : #accessing }
LbOperator >> kindArity [
	^kindArity
]

{ #category : #matching }
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

{ #category : #accessing }
LbOperator >> origins [
	^ origins
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

{ #category : #enumerating }
LbOperator >> withRanksDo: aBlock [
	ranks do: [ :each | aBlock value: each key value: each value ]
]
