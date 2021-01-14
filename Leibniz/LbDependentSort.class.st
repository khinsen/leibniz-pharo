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

{ #category : #converting }
LbDependentSort >> asLeibnizSyntaxString [
	^ term asLeibnizSyntaxString
]

{ #category : #lookup }
LbDependentSort >> directSupersorts [
	^ sortGraph directSupersortsOf: term
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

{ #category : #inspecting }
LbDependentSort >> gtSupersortsFor: aView [
	<gtView>
	^ aView mondrian
		title: 'Supersorts';
		priority: 1;
		painting: [ :view | 
			| graph |
			graph := self supersortGraph.
			view nodes
				shape: [ :x | self graphNodeForSort: x highlight: (x == self) ];
				with: (graph at: #nodes).
			view edges
				shape: [ BlLineElement new
							toHead: (BlArrowheadSimpleArrow new
										border: (BlBorder paint: Color gray width: 1));
							border: (BlBorder paint: Color gray width: 1) ];
				fromCenterTop;
				toCenterBottom;
				connect: (graph at: #edges)
					from: #first
					to: #second.
			view layout
				custom: (GtGradVerticalDominanceTreeLayout new reverse: true) ]
]

{ #category : #testing }
LbDependentSort >> includes: aSort [
	self flag: #todo.
	^ true
]

{ #category : #initialization }
LbDependentSort >> initializeWithSortGraph: aSortGraph term: aTerm [
	sortGraph := aSortGraph.
	term := aTerm.
	self beRecursivelyReadOnlyObject
]

{ #category : #accessing }
LbDependentSort >> kind [
	self flag: #todo.
	^ self
]

{ #category : #matching }
LbDependentSort >> match: aSort [
	^ self term match: aSort term
]

{ #category : #printing }
LbDependentSort >> printAsLeibnizSyntaxOn: aStream [
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
LbDependentSort >> sortGraph [
	^ sortGraph
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
	| edges nodes newNodes |
	edges := Set new.
	nodes := Set with: self.
	[ nodes isNotEmpty ] whileTrue: [
		newNodes := Set new.
		nodes do: [ :eachNode |
			eachNode directSupersorts do: [ :each |
				newNodes add: each.
				edges add: { eachNode. each } ] ].
		nodes := newNodes ].
	nodes := edges flatten.
	^ Dictionary with: #nodes -> nodes with: #edges -> edges
]

{ #category : #accessing }
LbDependentSort >> term [
	^ term
]
