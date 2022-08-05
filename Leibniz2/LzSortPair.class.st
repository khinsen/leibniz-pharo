Class {
	#name : #LzSortPair,
	#superclass : #Object,
	#traits : 'TLzEquality',
	#classTraits : 'TLzEquality classTrait',
	#instVars : [
		'sort1',
		'sort2',
		'sortGraph'
	],
	#category : #'Leibniz2-Sorts'
}

{ #category : #'instance creation' }
LzSortPair class >> sort1: aSort sort2: anotherSort [
	self assert: aSort sortGraph == anotherSort sortGraph.
	^ self new
		sortGraph: aSort sortGraph;
		sort1: aSort;
		sort2: anotherSort;
		beRecursivelyReadOnlyObject;
		yourself
]

{ #category : #lookup }
LzSortPair >> commonSortGraphRelation: aBlockOrSymbol [
	| distances1 distances2 css |
	distances1 := Dictionary with: sort1 -> 0.
	sortGraph
		breadthFirstTraversalFrom: sort1
		childNodes: aBlockOrSymbol
		nodesDo: [ :node :distance |
			distances1 at: node put: distance ]
		edgesDo: [ ].
	distances2 := Dictionary with: sort2 -> 0.
	sortGraph
		breadthFirstTraversalFrom: sort2
		childNodes: aBlockOrSymbol
		nodesDo: [ :node :distance |
			distances2 at: node put: distance ]
		edgesDo: [ ].
	css := (distances1 keys intersection:  distances2 keys)
			collect: [ :each |
				{ each. (distances1 at: each) min: (distances2 at: each) } ].
	css sort: [ :a :b | a second <= b second ].
	^ css
]

{ #category : #lookup }
LzSortPair >> commonSubsorts [
	^ self commonSortGraphRelation: #directSubsorts
]

{ #category : #lookup }
LzSortPair >> commonSupersorts [
	^ self commonSortGraphRelation: #directSupersorts
]

{ #category : #lookup }
LzSortPair >> greatestCommonSubsorts [
	| css leastDistance |
	css := self commonSubsorts.
	css ifEmpty: [ ^ Set new ].
	leastDistance := css first second.
	^ (css
		select: [ :each | each second = leastDistance ]
		thenCollect: #first) asSet
]

{ #category : #lookup }
LzSortPair >> greatestUniqueCommonSubsort [
	| css unique |
	css := self commonSubsorts.
	unique := (css groupedBy: #second) associations
		select: [ :each | each value size = 1 ].
	unique sort: [ :a :b | a key <= b key ].
	^ unique
		ifEmpty: [ nil ]
		ifNotEmpty: [ unique first value first first ]
]

{ #category : #inspecting }
LzSortPair >> gtGreatestCommonSubsortsFor: aView [
	<gtView>
	^ aView mondrian
		title: 'Greatest common subsorts';
		priority: 2;
		painting: [ :view |
			self
				paintGraphOn: view
				highlight: self greatestCommonSubsorts ]
]

{ #category : #inspecting }
LzSortPair >> gtLeastCommonSupersortsFor: aView [
	<gtView>
	^ aView mondrian
		title: 'Least common supersorts';
		priority: 3;
		painting: [ :view |
			self
				paintGraphOn: view
				highlight: self leastCommonSupersorts ]
]

{ #category : #inspecting }
LzSortPair >> gtSortGraphFor: aView [
	<gtView>
	^ aView mondrian
		title: 'Sort graph';
		priority: 0;
		painting: [ :view |
			self
				paintGraphOn: view
				highlight: Set new ]
]

{ #category : #inspecting }
LzSortPair >> gtSortsFor: aView [
	<gtView>
	^ aView list
		title: 'Sorts';
		priority: 1;
		items: [ { sort1. sort2 } ];
		itemText: #asLeibnizSyntax;
		yourself
]

{ #category : #lookup }
LzSortPair >> leastCommonSupersorts [
	| css leastDistance |
	sort1 <= sort2 ifTrue: [ ^ Set with: sort2 ].
	sort2 <= sort1 ifTrue: [ ^ Set with: sort1 ].
	css := self commonSupersorts.
	css ifEmpty: [ ^ Set new ].
	leastDistance := css first second.
	^ (css
		select: [ :each | each second = leastDistance ]
		thenCollect: #first) asSet
]

{ #category : #lookup }
LzSortPair >> leastUniqueCommonSupersort [
	| css unique |
	sort1 <= sort2 ifTrue: [ ^ sort2 ].
	sort2 <= sort1 ifTrue: [ ^ sort1 ].
	css := self commonSupersorts.
	unique := (css groupedBy: #second) associations
		select: [ :each | each value size = 1 ].
	unique sort: [ :a :b | a key <= b key ].
	^ unique
		ifEmpty: [ nil ]
		ifNotEmpty: [ unique first value first first ]
]

{ #category : #inspecting }
LzSortPair >> paintGraphOn: view highlight: aCollection [
	| graph lcs |
	graph := self subsortAndSupersortGraph.
	view nodes
		shape: [ :x |
			| highlight |
			(x = sort1 or: [ x = sort2 ])
				ifTrue: [ highlight := Color black ].
			(aCollection includes: x)
				ifTrue: [ highlight := Color blue ].
			LzGraphicsElements
				graphNodeLabelled: (x asLeibnizSyntaxString)
				highlightColor: highlight ];
		with: (graph at: #nodes).
	view edges
		shape: [ LzGraphicsElements graphArrow ];
		fromCenterTop;
		toCenterBottom;
		connect: (graph at: #edges) from: #first to: #second.
	view layout
		custom: (GtGradVerticalDominanceTreeLayout new reverse: true)
]

{ #category : #accessing }
LzSortPair >> referenceSlots [
	^ #(sortGraph)
]

{ #category : #accessing }
LzSortPair >> sort1 [
	^ sort1
]

{ #category : #accessing }
LzSortPair >> sort1: aSort [
	sort1 := aSort
]

{ #category : #accessing }
LzSortPair >> sort2 [
	^ sort2
]

{ #category : #accessing }
LzSortPair >> sort2: aSort [
	sort2 := aSort
]

{ #category : #accessing }
LzSortPair >> sortGraph [
	^ sortGraph
]

{ #category : #accessing }
LzSortPair >> sortGraph: aSortGraph [
	sortGraph := aSortGraph
]

{ #category : #lookup }
LzSortPair >> subsortAndSupersortGraph [
	| edges |
	edges :=
		(sort1 subsortAndSupersortGraph at: #edges) union: 
			(sort2 subsortAndSupersortGraph at: #edges).
	^ Dictionary
		with: #nodes -> edges flatten
		with: #edges -> edges
]

{ #category : #accessing }
LzSortPair >> valueSlots [
	^ #(sort1 sort2)
]
