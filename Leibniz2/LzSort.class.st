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

{ #category : #unifying }
LzSort >> addPrefix: aSymbol toVarsConflictingWith: aSort [
	^ term addPrefix: aSymbol toVarsConflictingWith: aSort term
]

{ #category : #comparing }
LzSort >> compareArguments: otherSort [
	term args ifEmpty: [ ^ false ].
	term args with: otherSort term args do: [ :term1 :term2 |
		term1 isSortSort
			ifTrue: [ (sortGraph sortWithTerm: term1) <= (sortGraph sortWithTerm: term2)
						ifFalse: [ ^ false ] ]
			ifFalse: [
				(term1 isRestrictionOf: term2)
					ifFalse: [ ^ false ] ] ].
	^ true
]

{ #category : #accessing }
LzSort >> directSupersorts [
	^ sortGraph directSupersortsOf: term
]

{ #category : #accessing }
LzSort >> family [
	^ sortGraph familyForSortTerm:  term
]

{ #category : #accessing }
LzSort >> gtGraphFor: aView [
	<gtView>
	^ aView mondrian
		title: 'Tree view';
		priority: 0;
		painting: [ :view | 
			| edges |
			view nodes
				shape: [ :x | sortGraph graphNodeForSort: x highlight: x = self ];
				with: self kind asSet.
			view edges
				shape: [ :x | sortGraph graphArrowForSubsortRelation: x ];
				fromCenterTop;
				toCenterBottom;
				connect: (sortGraph graphEdgesForSubset: self kind asSet)
					from: #subsort
					to: #supersort.
			view layout
				custom: (GtGradVerticalDominanceTreeLayout new reverse: true) ]
]

{ #category : #testing }
LzSort >> isSortSort [
	^ term args isEmpty and: [ term opName asSymbol = LzConstants opNameSort ]
]

{ #category : #accessing }
LzSort >> kind [
	^ self family kind
]

{ #category : #unifying }
LzSort >> matchAllSupersortsOf: aSort [
	| matches match |
	matches := Set new.
	(self term match: aSort term)
		ifSuccess: [ :m | matches add: m ].
	aSort directSupersorts do: [ :each |
		matches := matches union: (self matchAllSupersortsOf: each) ].
	^ matches
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

{ #category : #unifying }
LzSort >> substitute: bindings [
	^ sortGraph sortWithTerm: (term substitute: bindings)
]

{ #category : #unifying }
LzSort >> substituteAndReduce: bindings [
	self flag: #todo. "Do reduction"
	^ sortGraph sortWithTerm:
		(term substitute: bindings)
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
