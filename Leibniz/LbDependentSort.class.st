Class {
	#name : #LbDependentSort,
	#superclass : #Object,
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'term',
		'sortGraph'
	],
	#category : #'Leibniz-7-DependentSorts'
}

{ #category : #'instance creation' }
LbDependentSort class >> sortGraph: aSortGraph term: aTerm [
	^ self basicNew
		initializeWithSortGraph: aSortGraph term: aTerm;
		yourself
]

{ #category : #comparing }
LbDependentSort >> <= anotherSort [
	| myFamily otherFamily |
	self assert: self sortGraph equals: anotherSort sortGraph.
	self = anotherSort ifTrue: [ ^ true ].
	myFamily := self sortFamily.
	otherFamily := anotherSort sortFamily.
	myFamily = otherFamily
		ifTrue: [ ^ self compareArguments: anotherSort ]
		ifFalse: [ ^ self testPaths:
					(sortGraph pathsConnecting: myFamily to: otherFamily) ]
]

{ #category : #converting }
LbDependentSort >> asLeibnizSyntaxString [
	^ String streamContents: [ :s | self printAsLeibnizSyntaxOn: s ]
]

{ #category : #comparing }
LbDependentSort >> compareArguments: anotherSort [
	term arguments ifEmpty: [ ^ false ].
	term arguments with: anotherSort term arguments do: [ :term1 :term2 |
		term1 sort asLeibnizSyntaxString = #sort
			ifTrue: [ (sortGraph sortFor: term1) <= (sortGraph sortFor: term2)
						ifFalse: [ ^ false ] ]
			ifFalse: [ term1 = term2 ifFalse: [ ^ false ] ] ].
	^ true
]

{ #category : #lookup }
LbDependentSort >> directSubsorts [
	^ sortGraph directSubsortsOf: term
]

{ #category : #lookup }
LbDependentSort >> directSupersorts [
	^ sortGraph directSupersortsOf: term
]

{ #category : #lookup }
LbDependentSort >> family [
	^ sortGraph sortFamilyForTerm: term
]

{ #category : #inspecting }
LbDependentSort >> graphArrow [
	^ BlLineElement new
		toHead:
			(BlArrowheadSimpleArrow new
				border: (BlBorder paint: Color gray width: 1));
		border: (BlBorder paint: Color gray width: 1)
]

{ #category : #inspecting }
LbDependentSort >> graphNodeForSort: aSort highlight: aBoolean [
	| text color label rectangle |
	color := Color black.
	text := aSort asLeibnizSyntaxString asRopedText.
	text fontName: (LbCodeFont defaultFamily).
	text foreground: color.
	label := BlTextElement new text: text.

	aBoolean ifFalse: [
	 ^ label
		padding: (BlInsets all: 3);
		yourself ].

	rectangle := BlElement new
		background: color;
		geometry: (BlRoundedRectangleGeometry cornerRadius: 2);
		padding: (BlInsets all: 3);
		layout: BlLinearLayout horizontal;
		constraintsDo: [ :c |
			c horizontal fitContent.
			c vertical fitContent ].
	text foreground: Color white.
	rectangle addChild: label.
	^ rectangle
]

{ #category : #inspecting }
LbDependentSort >> gtFamilyFor: aView [
	<gtView>
	^ aView forward
		title: 'Family';
		priority: 3;
		object: [ self family ];
		view: #gtGraphFor:;
		yourself
]

{ #category : #inspecting }
LbDependentSort >> gtGraphFor: aView [
	<gtView>
	^ aView mondrian
		title: 'Graph';
		priority: 1;
		painting: [ :view | 
			| graph |
			graph := self subsortAndSupersortGraph.
			view nodes
				shape: [ :x | self graphNodeForSort: x highlight: x == self ];
				with: (graph at: #nodes).
			view edges
				shape: [ self graphArrow ];
				fromCenterTop;
				toCenterBottom;
				connect: (graph at: #edges) from: #first to: #second.
			view layout
				custom: (GtGradVerticalDominanceTreeLayout new reverse: true) ]
]

{ #category : #accessing }
LbDependentSort >> gtSortSyntaxFor: aView [
	<gtView>
	^ aView list
		title: 'Sort';
		priority: 0;
		items: [ { self } ];
		itemLbCode: [ :each | each asLeibnizSyntaxString ];
		yourself
]

{ #category : #testing }
LbDependentSort >> includes: aSort [
	self flag: #todo.
	self halt.
	^ true
]

{ #category : #initialization }
LbDependentSort >> initializeWithSortGraph: aSortGraph term: aTerm [
	sortGraph := aSortGraph.
	term := aTerm.
	self beRecursivelyReadOnlyObject
]

{ #category : #accessing }
LbDependentSort >> kindFamily [
	^ sortGraph kindFamilyForTerm: term
]

{ #category : #matching }
LbDependentSort >> match: aSort [
	^ self term match: aSort term
]

{ #category : #matching }
LbDependentSort >> matchAllSupersortsOf: aSort [
	| matches match |
	matches := Set new.
	match := self term match: aSort term.
	match isFailure ifFalse: [ matches add: match ].
	aSort directSupersorts do: [ :each |
		matches := matches union: (self matchAllSupersortsOf: each) ].
	^ matches
]

{ #category : #comparing }
LbDependentSort >> pairWith: aSort [
	^ LbDependentSortPair sortGraph: sortGraph sort1: self sort2: aSort
]

{ #category : #printing }
LbDependentSort >> printAsLeibnizSyntaxOn: aStream [
	term variables keysAndValuesDo:
		[ :var :sort |
			aStream nextPutAll: '∀ '.
			aStream nextPutAll: var asSymbol.
			aStream nextPut: $:.
			aStream nextPutAll: sort asLeibnizSyntaxString.
			aStream nextPutAll: ' '].
	term printAsLeibnizSyntaxOn: aStream
]

{ #category : #printing }
LbDependentSort >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	self printAsLeibnizSyntaxOn: aStream.
	aStream nextPut: $)
]

{ #category : #accessing }
LbDependentSort >> sortFamily [
	^ sortGraph sortFamilyForTerm: term
]

{ #category : #accessing }
LbDependentSort >> sortGraph [
	^ sortGraph
]

{ #category : #lookup }
LbDependentSort >> subsortAndSupersortGraph [
	| edges |
	edges := Set new.
	sortGraph
		breadthFirstTraversalFrom: self
		childNodes: #directSubsorts
		nodesDo: []
		edgesDo: [ :oldNode :newNode |
			edges add: { newNode. oldNode } ].
	sortGraph
		breadthFirstTraversalFrom: self
		childNodes: #directSupersorts
		nodesDo: []
		edgesDo: [ :oldNode :newNode |
			edges add: { oldNode. newNode } ].
	^ Dictionary
		with: #nodes -> edges flatten
		with: #edges -> edges
]

{ #category : #lookup }
LbDependentSort >> subsortGraph [
	| edges |
	edges := Set new.
	sortGraph
		breadthFirstTraversalFrom: self
		childNodes: #directSubsorts
		nodesDo: []
		edgesDo: [ :oldNode :newNode |
			edges add: { newNode. oldNode } ].
	^ Dictionary
		with: #nodes -> edges flatten
		with: #edges -> edges
]

{ #category : #matching }
LbDependentSort >> substitute: aSubstitution [
	^ sortGraph sortFor: (term substitute: aSubstitution)
]

{ #category : #matching }
LbDependentSort >> substituteAndReduce: aSubstitution [
	^ sortGraph normalizedSortFor: (term substitute: aSubstitution)
]

{ #category : #lookup }
LbDependentSort >> supersortGraph [
	| edges |
	edges := Set new.
	sortGraph
		breadthFirstTraversalFrom: self
		childNodes: #directSupersorts
		nodesDo: []
		edgesDo: [ :oldNode :newNode |
			edges add: { oldNode. newNode } ].
	^ Dictionary
		with: #nodes -> edges flatten
		with: #edges -> edges
]

{ #category : #accessing }
LbDependentSort >> term [
	^ term
]

{ #category : #comparing }
LbDependentSort >> testPaths: aSet [
	aSet do: [ :aPath |
		| currentSorts |
		currentSorts := { term }.
		aPath do: [ :aSegment |
			currentSorts :=
				currentSorts flatCollect: [ :aSort |
					(sortGraph axiomsConnecting: aSegment first to: aSegment second)
						collect: [ :anAxiom |
							anAxiom supersortOf: aSort ]
						thenSelect: #isNotNil ] ].
		currentSorts ifNotEmpty: [ ^ true ] ].
	^ false
]

{ #category : #matching }
LbDependentSort >> unify: aSort variables: variables [
	^ self term unify: aSort term variables: variables
]
