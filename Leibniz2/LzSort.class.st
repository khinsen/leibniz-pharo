Class {
	#name : #LzSort,
	#superclass : #Object,
	#traits : 'TLzEquality + TLzPrintable',
	#classTraits : 'TLzEquality classTrait + TLzPrintable classTrait',
	#instVars : [
		'sortGraph',
		'term'
	],
	#category : #'Leibniz2-Sorts'
}

{ #category : #comparing }
LzSort >> <= otherSort [
	| myFamily otherFamily |
	self assert: self sortGraph == otherSort sortGraph.
	self = otherSort ifTrue: [ ^ true ].
	myFamily := self family.
	otherFamily := otherSort family.
	myFamily = otherFamily
		ifTrue: [ ^ self compareArguments: otherSort ]
		ifFalse: [ 
			| candidates |
			candidates := self testPaths:
					(sortGraph pathsConnecting: myFamily to: otherFamily).
			candidates do: [ :each |
				self assert: each family equals: otherFamily.
				each = otherSort ifTrue: [ ^ true ].
				(each compareArguments: otherSort)
					ifTrue: [ ^ true ] ].
			^ false ]
]

{ #category : #converting }
LzSort >> addAsRopedTextTo: aRopedText [
	self term addAsRopedTextTo: aRopedText
]

{ #category : #unifying }
LzSort >> addPrefix: aSymbol toVarsConflictingWith: aSort [
	^ term addPrefix: aSymbol toVarsConflictingWith: aSort term
]

{ #category : #comparing }
LzSort >> compareArguments: otherSort [
	term args ifEmpty: [ ^ false ].
	term args size = otherSort term args size ifFalse: [ ^ false ].
	term args with: otherSort term args do: [ :term1 :term2 |
		term1 sort isSortSort
			ifTrue: [ (sortGraph sortWithTerm: term1) <= (sortGraph sortWithTerm: term2)
						ifFalse: [ ^ false ] ]
			ifFalse: [
				(term1 isRestrictionOf: term2)
					ifFalse: [ ^ false ] ] ].
	^ true
]

{ #category : #lookup }
LzSort >> directSubsorts [
	^ sortGraph directSubsortsOf: term
]

{ #category : #lookup }
LzSort >> directSupersorts [
	^ sortGraph directSupersortsOf: term
]

{ #category : #accessing }
LzSort >> family [
	^ sortGraph familyForSortTerm:  term
]

{ #category : #lookup }
LzSort >> greatestCommonSubsortWith: otherSort [
	^ (LzSortPair sort1: self sort2: otherSort) greatestUniqueCommonSubsort
]

{ #category : #inspecting }
LzSort >> gtGraphFor: aView [
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
					LzGraphicsElements
						graphNodeLabelled: x asLeibnizSyntaxString
						highlightColor: highlight ];
				with: (graph at: #nodes).
			view edges
				shape: [ LzGraphicsElements graphArrow ];
				fromCenterTop;
				toCenterBottom;
				connect: (graph at: #edges) from: #first to: #second.
			view layout
				custom: (GtGradVerticalDominanceTreeLayout new reverse: true) ]
]

{ #category : #accessing }
LzSort >> gtSortGraphFor: aView [
	<gtView>
	^ aView forward
		title: 'Sort graph';
		priority: 10;
		object: [ self sortGraph ];
		view: #gtGraphFor:;
		yourself
]

{ #category : #testing }
LzSort >> isBooleanSort [
	term args ifNotEmpty: [ ^ false ].
	^ term opName
		ifNil: [ false ]
		ifNotNil: [ :n |
			n asSymbol = LzConstants opNameBoolean ]
]

{ #category : #testing }
LzSort >> isInfix [
	^ term isInfix
]

{ #category : #testing }
LzSort >> isSortSort [
	term args ifNotEmpty: [ ^ false ].
	^ term opName
		ifNil: [ false ]
		ifNotNil: [ :n |
			n asSymbol = LzConstants opNameSort ]
]

{ #category : #accessing }
LzSort >> kind [
	^ self family kind
]

{ #category : #lookup }
LzSort >> leastCommonSupersortWith: otherSort [
	^ (LzSortPair sort1: self sort2: otherSort) leastUniqueCommonSupersort
]

{ #category : #unifying }
LzSort >> matchWithSupersortsOf: aSort [
	| bindings matches matchBindings matchVariables |
	self flag: #todo. "Use matchAllowingVars: ?"
	bindings := LzBindings new
					sortGraph: self sortGraph.
	self term match: aSort term bindings: bindings.
	bindings ifSuccess: [ ^ bindings ].

	matches := Set new.
	aSort directSupersorts do: [ :each |
		(self matchWithSupersortsOf: each)
			ifSuccess: [ :b | matches add: b ] ].
	matches ifEmpty: [ ^ LzBindings new
							failUnless: aSort isSubsortOf: self ].
	matches size = 1 ifTrue: [ ^ matches anyOne ].
	"There are multiple matches. This is allowed only if there is a unique
	least sort among them. This means that all non-sort variable bindings
	must be equal, and for each sort variable binding, one value is a subsort
	of all the others."
	matches := matches asArray.
	matchBindings := matches collect: #bindings.
	matches first nonSortVars do: [ :eachVarName |
		(matchBindings collect: [ :b | b at: eachVarName ])
			asSet size > 1 ifTrue: [ self error: 'Conflicting matches' ] ].
	matches first sortVars do: [ :eachVarName |
		| sorts |
		sorts := matchBindings collect: [ :b |
			self sortGraph sortWithTerm: (b at: eachVarName) ].
		1 to: sorts size do: [ :index1 |
			| least |
			least := true.
			1 to: sorts size do: [ :index2 |
				(sorts at: index1) <= (sorts at: index2)
					ifFalse: [ least := false ] ].
			least ifTrue: [ ^ matches at: index1 ] ] ].
	self error: 'Conflicting matches'.
]

{ #category : #comparing }
LzSort >> min: aSort [
	self <= aSort ifTrue: [ ^ self ].
	aSort <= self ifTrue: [ ^ aSort ].
	^ nil
]

{ #category : #printing }
LzSort >> printAsLeibnizSyntaxOn: aStream [
	self term printAsLeibnizSyntaxOn: aStream
]

{ #category : #accessing }
LzSort >> referenceSlots [
	^ #(sortGraph)
]

{ #category : #accessing }
LzSort >> sortGraph [
	^ sortGraph
]

{ #category : #accessing }
LzSort >> sortGraph: aSortGraph [
	sortGraph := aSortGraph
]

{ #category : #lookup }
LzSort >> subsortAndSupersortGraph [
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
		with: #nodes -> (edges flatten union: (Set with: self))
		with: #edges -> edges
]

{ #category : #lookup }
LzSort >> subsortGraph [
	| edges |
	edges := Set new.
	sortGraph
		breadthFirstTraversalFrom: self
		childNodes: #directSubsorts
		nodesDo: []
		edgesDo: [ :oldNode :newNode |
			edges add: { newNode. oldNode } ].
	^ Dictionary
		with: #nodes -> (edges flatten union: (Set with: self))
		with: #edges -> edges
]

{ #category : #unifying }
LzSort >> substitute: bindings [
	^ sortGraph sortWithTerm: (term substitute: bindings)
]

{ #category : #unifying }
LzSort >> substituteAndReduce: bindings [
	^ sortGraph normalizedSortWithTerm:
		(term substitute: bindings)
]

{ #category : #accessing }
LzSort >> supersortGraph [
	| edges |
	edges := Set new.
	sortGraph
		breadthFirstTraversalFrom: self
		childNodes: #directSupersorts
		nodesDo: []
		edgesDo: [ :oldNode :newNode |
			edges add: { oldNode. newNode } ].
	^ Dictionary
		with: #nodes -> (edges flatten union: (Set with: self))
		with: #edges -> edges
]

{ #category : #accessing }
LzSort >> term [
	^ term
]

{ #category : #accessing }
LzSort >> term: aTerm [
	term := aTerm
]

{ #category : #comparing }
LzSort >> testPaths: aSet [
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
			candidates add: (sortGraph sortWithTerm: each) ] ].
	^ candidates
]

{ #category : #accessing }
LzSort >> valueSlots [
	^ #(term)
]

{ #category : #accessing }
LzSort >> vars [
	^ term vars
]
