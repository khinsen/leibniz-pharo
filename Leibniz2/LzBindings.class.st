Class {
	#name : #LzBindings,
	#superclass : #Object,
	#traits : 'TLzEquality',
	#classTraits : 'TLzEquality classTrait',
	#instVars : [
		'vars',
		'failure',
		'sortGraph'
	],
	#category : #'Leibniz2-Terms'
}

{ #category : #accessing }
LzBindings >> bindToUniqueVar: aBlock [
	| varSets |
	self ifFailure: [ ^ self ].
	self unboundVarSets keysAndValuesDo: [ :rootNode :names |
		| varTerm |
		varTerm := aBlock value: names value: rootNode sort.
		self bindVar: rootNode name sort: rootNode sort to: varTerm ]
]

{ #category : #accessing }
LzBindings >> bindVar: aVarName sort: aSort to: aTerm [
	| root |
	self ifFailure: [ ^ self ].
	self assert: (vars at: aVarName) sort equals: aSort.
	(self findRootFor: aVarName)
		unifyWithValue: aTerm bindings: self
]

{ #category : #accessing }
LzBindings >> bindingFor: aName [
	self ifFailure: [ ^ nil ].
	vars at: aName ifAbsent: [ ^ nil ].
	^ (self findRootFor: aName) value
]

{ #category : #accessing }
LzBindings >> bindings [
	^ (self varNodes collect: [ :each |
		each name -> (self findRootFor: each name) value ]
		thenSelect: [ :each | each value isNotNil ])
		asDictionary
]

{ #category : #combining }
LzBindings >> combineWith: otherBindings [
	self ifFailure: [ ^ self ].
	otherBindings ifFailure: [ :f | failure := f. ^ self ].
	otherBindings varNodes do: [ :each |
		self defineVar: each name sort: each sort ].
	otherBindings varNodes do: [ :each |
		| root |
		root := otherBindings findRootFor: each name.
		self makeVar: each name sort: each sort equalToVar: root name sort: root sort.
		(self findRootFor: each name)
			unifyWithValue: root value bindings: self ]
]

{ #category : #binding }
LzBindings >> defineVar: aVarName sort: aSort [
	vars at: aVarName
		ifPresent: [ :node | self assert: node sort equals: aSort ]
		ifAbsentPut: [
			(aSort isSortSort
				ifTrue: [ LzBindingsSortVarNode ]
				ifFalse: [ LzBindingsVarNode ]) new
					name: aVarName;
					sort: aSort ]	
]

{ #category : #failing }
LzBindings >> failUnless: aSort isSubsortOf: otherSort [
	failure ifNil: [
		aSort <= otherSort ifFalse: [
			failure := { #notSubsort. aSort. otherSort } ] ]
]

{ #category : #failing }
LzBindings >> failWith: aSort incommensurableWith: otherSort [
	failure ifNil: [
		failure := { #incommensurableSorts. aSort. otherSort } ]
]

{ #category : #failing }
LzBindings >> failWith: aTerm notUnifiableWith: otherTerm [
	failure ifNil: [
		failure := { #nonUnifiableTerms. aTerm. otherTerm } ]
]

{ #category : #accessing }
LzBindings >> findRootFor: aVarName [
	| node |
	node := vars at: aVarName.
	node parent ifNil: [ ^ node ].
	node parent: (self findRootFor: node parent name).
	^ node parent
]

{ #category : #inspecting }
LzBindings >> gtBindingsFor: aView [
	<gtView>
	| bindings |
	bindings := self bindings.
	bindings ifEmpty: [ ^ aView empty ].
	^ aView columnedList
		title: 'Bindings';
		priority: 1;
		items: [ bindings keys sorted ];
		column: 'Name' lzCode: #asSymbol;
		column: 'Sort' lzCode: [ :each | (vars at: each) sort asLeibnizSyntaxString ];
		column: 'Value' lzCode: [ :each | (bindings at: each) asLeibnizSyntaxString ];
		yourself
]

{ #category : #printing }
LzBindings >> gtDisplayOn: aStream [
	failure ifNil: [
		self printUnboundOn: aStream.
		self bindings ifNotEmpty: [
			self unboundVarSets ifNotEmpty: [ aStream nextPutAll: ', ' ] ].
		self printBoundOn: aStream ]
		ifNotNil: [ self printFailureOn: aStream ]
]

{ #category : #inspecting }
LzBindings >> gtFailureFor: aView [
	<gtView>
	failure ifNil: [ ^ aView empty ].
	^ aView list
		title: 'Failure';
		priority: 0;
		items: [ { failure first.
					failure second asLeibnizSyntaxString.
					failure third asLeibnizSyntaxString } ];
		itemLzCode: [ :each | each ];
		yourself
]

{ #category : #inspecting }
LzBindings >> gtUnboundFor: aView [
	<gtView>
	| unbound |
	unbound := self unboundVarSets.
	unbound ifEmpty: [ ^ aView empty ].
	^ aView columnedList
		title: 'Unbound';
		priority: 2;
		items: [ unbound values ];
		column: 'Names' lzCode: [ :each |
			' = ' join: (each collect: #asSymbol) ];
		column: 'Sort' lzCode: [ :each |
			(vars at: each anyOne) sort asLeibnizSyntaxString ];
		yourself
]

{ #category : #testing }
LzBindings >> hasNoBindings [
	^ self bindings isEmpty
]

{ #category : #testing }
LzBindings >> ifFailure: aBlock [
	^ failure
		ifNotNil: [ aBlock cull: failure ]
]

{ #category : #testing }
LzBindings >> ifSuccess: aBlock [
	^ failure
		ifNil: [ aBlock cull: self ]
]

{ #category : #testing }
LzBindings >> ifSuccess: block1 ifFailure: block2 [
	^ failure
		ifNil: [ block1 cull: self ]
		ifNotNil: [ block2 cull: failure ]
]

{ #category : #initializing }
LzBindings >> initialize [
	vars := Dictionary new.
]

{ #category : #accessing }
LzBindings >> makeVar: aVarName sort: aSort equalToVar: otherVarName sort: otherSort [
	| root1 root2 |
	failure ifNotNil: [ ^ self ].
	aVarName = otherVarName ifTrue: [ ^ self ].
	self assert: (vars at: aVarName) sort equals: aSort.
	self assert: (vars at: otherVarName) sort equals: otherSort.
	root1 := self findRootFor: aVarName.
	root2 := self findRootFor: otherVarName.
	root1 == root2 ifTrue: [ ^ self ].
	root1 rank < root2 rank
		ifTrue: [ | temp | temp := root1. root1 := root2. root2 := temp ].
	root2 parent: root1.
	root1 value ifNil: [ root1 value: root2 value ].
	self assert: root1 value equals: root2 value.
	root1 rank = root2 rank
		ifTrue: [ root1 incrementRank ].
]

{ #category : #accessing }
LzBindings >> nonSortVars [
	^ vars associations
		select: [ :each |
			each value sort isSortSort not ]
		thenCollect: #key
]

{ #category : #printing }
LzBindings >> printBoundOn: aStream [
	| bound |
	bound := self bindings.
	bound keys sorted
		do: [ :each | 
			aStream nextPutAll: each asString.
			aStream nextPut: $=.
			(bound at: each) printAsLeibnizSyntaxOn: aStream ]
		separatedBy: [ aStream nextPutAll: ', ' ]
]

{ #category : #printing }
LzBindings >> printFailureOn: aStream [
	aStream nextPutAll: 'failure #'.
	aStream nextPutAll: failure first.
	aStream nextPutAll: ': '.
	failure allButFirst do: [ :each |
		each printAsLeibnizSyntaxOn: aStream. ]
		separatedBy: [ aStream nextPutAll: ', ' ]
]

{ #category : #printing }
LzBindings >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	self gtDisplayOn: aStream.
	aStream nextPut: $)
]

{ #category : #printing }
LzBindings >> printUnboundOn: aStream [
	| varSets |
	varSets := self unboundVarSets values asSet asArray
				collect: [ :each | each asArray sorted ].
	varSets sort: [ :a :b | a first <= b first ].
	varSets do: [ :eachVarSet | 
		eachVarSet asArray sorted
			do: [ :eachVarName | aStream nextPutAll: eachVarName asString ]
			separatedBy: [ aStream nextPut: $= ] ]
		separatedBy: [ aStream nextPutAll: ', ' ]
]

{ #category : #accessing }
LzBindings >> sortGraph [
	^ sortGraph
]

{ #category : #accessing }
LzBindings >> sortGraph: aSortGraph [
	sortGraph := aSortGraph
]

{ #category : #accessing }
LzBindings >> sortVars [
	^ vars associations
		select: [ :each |
			each value sort isSortSort ]
		thenCollect: #key
]

{ #category : #private }
LzBindings >> unboundVarSets [
	| varSets |
	self ifFailure: [ ^ Set new ].
	varSets := Dictionary new.
	self varNodes select: [ :each |
		each parent isNil and: [ each value isNil ] ]
		thenDo: [ :each | varSets at: each  put: Set new ].
	self varNodes do: [ :each |
		varSets at: (self findRootFor: each name)
			ifPresent: [ :s | s add: each name ] ].
	^ varSets
]

{ #category : #accessing }
LzBindings >> unify: v with: aTerm sort: aSort [
	aSort isSortSort
		ifTrue: []
		ifFalse: [
			v = aTerm ifFalse: [ self failWith: aTerm notUnifiableWith: v ].
			^ v ]
]

{ #category : #accessing }
LzBindings >> valueSlots [
	^ #(vars failure)
]

{ #category : #private }
LzBindings >> varNodes [
	^ vars values
]
