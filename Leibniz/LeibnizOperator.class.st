"
See ${class:name=LeibnizSignature}$.


"
Class {
	#name : #LeibnizOperator,
	#superclass : #Object,
	#instVars : [
		'opSymbol',
		'kindArity',
		'kind',
		'ranks',
		'sortGraph'
	],
	#category : #'Leibniz-2-Signatures'
}

{ #category : #'instance creation' }
LeibnizOperator class >> symbol: aSymbol argKindConstraints: aKindConstraintArray kind: aKind [
	^ self basicNew
			 initializeWithSymbol: aSymbol argKindConstraints: aKindConstraintArray kind: aKind;
			 yourself.

]

{ #category : #adding }
LeibnizOperator >> addArity: newArity withSort: newSort [
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
				ifTrue: [ self assertMonotonicity: [ sortGraph is: s subsortOf: newSort ]
									forArity: newArity andSort: newSort]. ].

	ranks add: newArity -> newSort.
]

{ #category : #viewing }
LeibnizOperator >> addGraphToBuilder: aBuilder [
	| saGraph |
	aBuilder shape label
		text: [ :r | (String streamContents:
							[ :s | self printForArity: r key withSort: r value On: s ])];
		fontName: 'Arial Unicode MS';
		color: (Color black).
	aBuilder nodes: ranks.
	aBuilder shape arrowedLine withShorterDistanceAttachPoint.
	saGraph := self minimalSubArityGraph.
	saGraph withIndicesDo:
		[ :edge :i :j |
		  edge = 1 ifTrue:
				[ aBuilder edges connectFrom: (ranks at: i) to: (ranks at: j) ] ].
]

{ #category : #'error signalling' }
LeibnizOperator >> assertMonotonicity: aBlock forArity: anArity andSort: aSort [
	self assert: aBlock
		  description: 'new rank ', anArity printString,
							' -> ', aSort asString, ' makes operator non-monotonic'.
]

{ #category : #inspecting }
LeibnizOperator >> gtInspectorNetworkViewIn: composite [
	<gtInspectorPresentationOrder: -10>
	composite roassal2
		title: 'Network View';
		initializeView: self networkView.

]

{ #category : #inspecting }
LeibnizOperator >> gtInspectorTreeViewIn: composite [
	<gtInspectorPresentationOrder: -11>
	composite roassal2
		title: 'Tree View';
		initializeView: self treeView.

]

{ #category : #initializing }
LeibnizOperator >> initializeWithSymbol: aSymbol argKindConstraints: aKindConstraintArray kind: aKind [
	opSymbol := aSymbol.
	kindArity := aKindConstraintArray.
	kind := aKind.
	sortGraph := kind sortGraph.
	ranks := OrderedCollection new.


]

{ #category : #accessing }
LeibnizOperator >> kind [
	^kind
]

{ #category : #accessing }
LeibnizOperator >> kindArity [
	^kindArity
]

{ #category : #accessing }
LeibnizOperator >> leastRankForArgSorts: aSortArray [
	| arity |
	aSortArray ifEmpty: [ self assert: ranks size equals: 1 .
								 ^ ranks first ].
	arity := LeibnizArity sortGraph: sortGraph argSorts: aSortArray.
	^ ranks detect: [ :r | arity <= r key ]
			  ifNone: [ kindArity -> kind ].
]

{ #category : #viewing }
LeibnizOperator >> minimalSubArityGraph [
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

{ #category : #viewing }
LeibnizOperator >> networkView [
	| b |
	b := RTMondrian new.
	self addGraphToBuilder: b.
	b layout forceWithCharge: (ranks size * 1000 - 15000 min: -2000).
	b build.
	^ b view

]

{ #category : #accessing }
LeibnizOperator >> opSymbol [
	^opSymbol
]

{ #category : #printing }
LeibnizOperator >> printForArity: anArity On: aStream [
	"Note: this is a first quick-and-dirty implementation. It will be replaced
	 by an output formatter that also handles terms."
	| opString |
	opString := opSymbol asString.
	"If the symbol starts with an underscore, it's an infix operator"
	opString first = $_
		ifTrue:
			[ self assert: anArity size equals: 2.
			  anArity first printAsLeibnizSyntaxOn: aStream.
			  aStream nextPutAll: ' '.
			  aStream nextPutAll: opString allButFirst.
			  aStream nextPutAll: ' '.
			  anArity second printAsLeibnizSyntaxOn: aStream. ]
		ifFalse: "No support for the three special operators for now - see comment above!"
			[ aStream nextPutAll: opString.
			  anArity ifNotEmpty:
			  	[ aStream nextPut: $(.
				  anArity allButLastDo:
					[ :each |
						each printAsLeibnizSyntaxOn: aStream.
						aStream nextPutAll: ', ' ].
				  anArity last printAsLeibnizSyntaxOn: aStream.
				  aStream nextPut: $) ]. ].

]

{ #category : #printing }
LeibnizOperator >> printForArity: anArity withSort: aSort On: aStream [
	self printForArity: anArity On: aStream.
	aStream nextPutAll: ' : '.
	aStream nextPutAll: aSort asString.

]

{ #category : #printing }
LeibnizOperator >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	aStream nextPutAll: opSymbol.
	aStream nextPutAll: ': '.
	kindArity printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: ' -> '.
	kind printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: ', '.
	ranks size printOn: aStream.
	aStream nextPutAll: ' ranks)'.

]

{ #category : #accessing }
LeibnizOperator >> ranksMatchingArgSorts: aSortArray [
	| arity |
	arity := LeibnizArity sortGraph: sortGraph argSorts: aSortArray.
	^ ranks select: [ :r | arity <= r key ]
]

{ #category : #accessing }
LeibnizOperator >> size [
	^ranks size
]

{ #category : #accessing }
LeibnizOperator >> sortForArgSorts: aSortArray [
	^ (self leastRankForArgSorts: aSortArray) value
]

{ #category : #viewing }
LeibnizOperator >> subArityGraph [
	^Array2D new: ranks size tabulate:
		[ :i :j |
			(i ~= j and: [ (ranks at: i) key <= (ranks at: j) key ])
				ifTrue: [ 1 ] ifFalse: [ 0 ] ]

]

{ #category : #inspecting }
LeibnizOperator >> title [
	^String streamContents:
		[ :stream |
			self printForArity: kindArity On: stream.
			stream nextPutAll: ' : '.
			self kind printAsLeibnizSyntaxOn: stream. ]
]

{ #category : #viewing }
LeibnizOperator >> treeView [
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
LeibnizOperator >> withRanksDo: aBlock [
	ranks do: [ :r |  aBlock value: r key value: r value ]
]
