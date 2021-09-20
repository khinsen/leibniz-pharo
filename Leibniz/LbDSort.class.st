Class {
	#name : 'LbDSort',
	#superclass : 'Object',
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'term',
		'sortGraph'
	],
	#category : 'Leibniz-7-DependentSorts'
}

{ #category : 'instance creation' }
LbDSort class >> sortGraph: aSortGraph term: aTerm [
	^ self basicNew
		initializeWithSortGraph: aSortGraph term: aTerm;
		yourself
]

{ #category : 'comparing' }
LbDSort >> <= anotherSort [
	| myFamily otherFamily |
	self assert: self sortGraph equals: anotherSort sortGraph.
	self = anotherSort ifTrue: [ ^ true ].
	myFamily := self sortFamily.
	otherFamily := anotherSort sortFamily.
	myFamily = otherFamily
		ifTrue: [ ^ self compareArguments: anotherSort ]
		ifFalse: [ 
			| candidates |
			candidates := self testPaths:
					(sortGraph pathsConnecting: myFamily to: otherFamily).
			candidates do: [ :each |
				self assert: each sortFamily equals: otherFamily.
				each = anotherSort ifTrue: [ ^ true ].
				(each compareArguments: anotherSort)
					ifTrue: [ ^ true ] ].
			^ false ]
]

{ #category : 'matching' }
LbDSort >> addPrefix: aSymbol toVarsConflictingWith: aSort [
	^ term addPrefix: aSymbol toVarsConflictingWith: aSort term
]

{ #category : 'converting' }
LbDSort >> asLeibnizSyntaxString [
	^ String streamContents: [ :s | self printAsLeibnizSyntaxOn: s ]
]

{ #category : 'comparing' }
LbDSort >> compareArguments: anotherSort [
	term arguments ifEmpty: [ ^ false ].
	term arguments with: anotherSort term arguments do: [ :term1 :term2 |
		term1 sort asLeibnizSyntaxString = #sort
			ifTrue: [ (sortGraph sortFor: term1) <= (sortGraph sortFor: term2)
						ifFalse: [ ^ false ] ]
			ifFalse: [ (term1 isRestrictionOf: term2) ifFalse: [ ^ false ] ] ].
	^ true
]

{ #category : 'lookup' }
LbDSort >> directSubsorts [
	^ sortGraph directSubsortsOf: term
]

{ #category : 'lookup' }
LbDSort >> directSupersorts [
	^ sortGraph directSupersortsOf: term
]

{ #category : 'lookup' }
LbDSort >> family [
	^ sortGraph sortFamilyForTerm: term
]

{ #category : 'inspecting' }
LbDSort >> gtFamilyFor: aView [
	<gtView>
	^ aView forward
		title: 'Family';
		priority: 3;
		object: [ self family ];
		view: #gtGraphFor:;
		yourself
]

{ #category : 'inspecting' }
LbDSort >> gtGraphFor: aView [
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
					x = self
						ifTrue: [ highlight :=  Color black ].
					LbGraphicsElements
						graphNodeLabelled: x asLeibnizSyntaxString
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
LbDSort >> gtSortSyntaxFor: aView [
	<gtView>
	^ aView list
		title: 'Sort';
		priority: 0;
		items: [ { self } ];
		itemLbCode: [ :each | each asLeibnizSyntaxString ];
		yourself
]

{ #category : 'testing' }
LbDSort >> includes: aSort [
	self flag: #todo.
	self halt.
	^ true
]

{ #category : 'initialization' }
LbDSort >> initializeWithSortGraph: aSortGraph term: aTerm [
	sortGraph := aSortGraph.
	term := aTerm.
	self beRecursivelyReadOnlyObject
]

{ #category : 'accessing' }
LbDSort >> kind [
	^ sortGraph kindForTerm: term
]

{ #category : 'matching' }
LbDSort >> match: aSort [
	^ self term match: aSort term
]

{ #category : 'matching' }
LbDSort >> matchAllSupersortsOf: aSort [
	| matches match |
	matches := Set new.
	match := self term match: aSort term.
	match isFailure ifFalse: [ matches add: match ].
	aSort directSupersorts do: [ :each |
		matches := matches union: (self matchAllSupersortsOf: each) ].
	^ matches
]

{ #category : 'comparing' }
LbDSort >> pairWith: aSort [
	^ LbDSortPair sortGraph: sortGraph sort1: self sort2: aSort
]

{ #category : 'printing' }
LbDSort >> printAsLeibnizSyntaxOn: aStream [
	term printAsLeibnizSyntaxOn: aStream
]

{ #category : 'printing' }
LbDSort >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	self printAsLeibnizSyntaxOn: aStream.
	aStream nextPut: $)
]

{ #category : 'accessing' }
LbDSort >> sortFamily [
	^ sortGraph sortFamilyForTerm: term
]

{ #category : 'accessing' }
LbDSort >> sortGraph [
	^ sortGraph
]

{ #category : 'lookup' }
LbDSort >> subsortAndSupersortGraph [
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

{ #category : 'lookup' }
LbDSort >> subsortGraph [
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

{ #category : 'matching' }
LbDSort >> substitute: aSubstitution [
	^ sortGraph sortFor: (term substitute: aSubstitution)
]

{ #category : 'matching' }
LbDSort >> substituteAndReduce: aSubstitution [
	^ sortGraph normalizedSortFor: (term substitute: aSubstitution)
]

{ #category : 'lookup' }
LbDSort >> supersortGraph [
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

{ #category : 'accessing' }
LbDSort >> term [
	^ term
]

{ #category : 'comparing' }
LbDSort >> testPaths: aSet [
	| candidates |
	candidates := Set new.
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
		currentSorts do: [ :each |
			candidates add:
				(LbDSort sortGraph: sortGraph term: each) ] ].
	^ candidates
]

{ #category : 'matching' }
LbDSort >> unify: aSort [
	^ self term unify: aSort term
]

{ #category : 'matching' }
LbDSort >> unify: aSort variables: variables [
	^ self term unify: aSort term variables: variables
]

{ #category : 'accessing' }
LbDSort >> variables [
	^ term variables
]
