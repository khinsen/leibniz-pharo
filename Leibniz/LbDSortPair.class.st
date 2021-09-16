"
This class provides inspector views that help in understanding the relation between two sorts in the same sort graph.
"
Class {
	#name : 'LbDSortPair',
	#superclass : 'Object',
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'sortGraph',
		'sort1',
		'sort2'
	],
	#category : 'Leibniz-7-DependentSorts'
}

{ #category : 'instance creation' }
LbDSortPair class >> sortGraph: aSortGraph sort1: sort1 sort2: sort2 [
	^ self basicNew
		initializeWithSortGraph: aSortGraph sort1: sort1 sort2: sort2;
		yourself
]

{ #category : 'inspecting' }
LbDSortPair >> gtGraphFor: aView [
	<gtView>
	^ aView mondrian
		title: 'Graph';
		priority: 1;
		painting: [ :view | 
			| graph |
			graph := self subsortAndSupersortGraph.
			view nodes
				shape: [ :x |
					| highlight |
					highlight := (x = sort1 or: [ x = sort2 ])
						ifTrue: [ Color black ] ifFalse: [ nil ].
					LbGraphicsElements
						graphNodeLabelled: (x asLeibnizSyntaxString)
						highlightColor: highlight ];
				with: (graph at: #nodes).
			view edges
				shape: [ LbGraphicsElements graphArrow ];
				fromCenterTop;
				toCenterBottom;
				connect: (graph at: #edges) from: #first to: #second.
			view layout
				custom: (GtGradVerticalDominanceTreeLayout new reverse: true) ]
]

{ #category : 'accessing' }
LbDSortPair >> gtLeastCommonSubsortsFor: aView [
	<gtView>
	^ aView mondrian
		title: 'Least common subsorts';
		priority: 2;
		painting: [ :view | 
			| graph lcs |
			graph := self subsortAndSupersortGraph.
			lcs := self leastCommonSubsorts.
			view nodes
				shape: [ :x |
					| highlight |
					(x = sort1 or: [ x = sort2 ])
						ifTrue: [ highlight := Color black ].
					(lcs includes: x)
						ifTrue: [ highlight := Color blue ].
					LbGraphicsElements
						graphNodeLabelled: (x asLeibnizSyntaxString)
						highlightColor: highlight ];
				with: (graph at: #nodes).
			view edges
				shape: [ LbGraphicsElements graphArrow ];
				fromCenterTop;
				toCenterBottom;
				connect: (graph at: #edges) from: #first to: #second.
			view layout
				custom: (GtGradVerticalDominanceTreeLayout new reverse: true) ]
]

{ #category : 'inspecting' }
LbDSortPair >> gtSortsFor: aView [
	<gtView>
	^ aView list
		title: 'Sorts';
		priority: 0;
		items: [ { sort1. sort2 } ];
		yourself
]

{ #category : 'initializing' }
LbDSortPair >> initializeWithSortGraph: aSortGraph sort1: aSort sort2: anotherSort [
	sortGraph := aSortGraph.
	sort1 := aSort.
	sort2 := anotherSort
]

{ #category : 'operating' }
LbDSortPair >> leastCommonSubsorts [
	| distances1 distances2 lcs1 lcs2 |
	distances1 := Dictionary new.
	sortGraph
		breadthFirstTraversalFrom: sort1
		childNodes: #directSubsorts
		nodesDo: [ :node :distance |
			distances1 at: node put: distance ]
		edgesDo: [ ].
	distances2 := Dictionary new.
	sortGraph
		breadthFirstTraversalFrom: sort2
		childNodes: #directSubsorts
		nodesDo: [ :node :distance |
			distances2 at: node put: distance ]
		edgesDo: [ ].
	lcs1 := distances1 associationsSelect: [ :each |
		each value = 1
		and: [ distances2 includesKey: each key ] ].
	lcs2 := distances2 associationsSelect: [ :each |
		each value = 1
		and: [ distances1 includesKey: each key ] ].
	^ (lcs1 keys union: lcs2 keys) asSet
]

{ #category : 'accessing' }
LbDSortPair >> subsortAndSupersortGraph [
	| edges |
	edges := Set new.
	{ sort1. sort2 } do: [ :each |
		sortGraph
			breadthFirstTraversalFrom: each
			childNodes: #directSubsorts
			nodesDo: []
			edgesDo: [ :oldNode :newNode |
				edges add: { newNode. oldNode } ].
		sortGraph
			breadthFirstTraversalFrom: each
			childNodes: #directSupersorts
			nodesDo: []
			edgesDo: [ :oldNode :newNode |
				edges add: { oldNode. newNode } ] ].
	^ Dictionary
		with: #nodes -> edges flatten
		with: #edges -> edges
]

{ #category : 'operating' }
LbDSortPair >> subsortByUnification [
	| rename preferredVarNames substitution equalUpToRenaming |
	rename := sort2 addPrefix: #'temp.' toVarsConflictingWith: sort1.
	preferredVarNames := sort1 variables keys.
	substitution := (sort2 substitute: rename) unify: sort1.
	substitution isFailure ifTrue: [ ^ nil ].
	equalUpToRenaming := substitution hasNoBindings
		and: [ sort1 variables size = sort2 variables size ].
	substitution bindToUniqueVar: [ :varSet :sort |
		| name |
		varSet size = 2 ifFalse: [ equalUpToRenaming := false ].
		name := (varSet intersection: preferredVarNames) asArray sorted
					ifEmpty: [ varSet anyOne ]
					ifNotTempy: [ :anArray | anArray first ].
		LbVarTerm name: name sort: sort signature: sortGraph context signature ].
	equalUpToRenaming ifTrue: [ ^ sort1 ].
	^ sort1 substitute: substitution
]
