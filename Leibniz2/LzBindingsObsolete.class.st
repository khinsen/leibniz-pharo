Class {
	#name : #LzBindingsObsolete,
	#superclass : #Object,
	#traits : 'TLzEquality',
	#classTraits : 'TLzEquality classTrait',
	#instVars : [
		'sorts',
		'bound',
		'unbound',
		'failure'
	],
	#category : #'Leibniz2-Terms'
}

{ #category : #binding }
LzBindingsObsolete >> bindToUniqueVar: aBlock [
	| varSetBindings |
	self ifFailure: [ ^ self ].
	varSetBindings := Dictionary new.
	unbound values asSet do: [ :each |
		varSetBindings at: each put: (aBlock value: each value: (sorts at: each)) ].
	varSetBindings keysAndValuesDo: [ :varSet :uniqueVarTerm |
		| aVar |
		aVar := varSet anyOne.
		self bindVar: aVar sort:(sorts at: aVar) to: uniqueVarTerm  ]	
]

{ #category : #binding }
LzBindingsObsolete >> bindVar: aSymbol sort: aSort to: aTerm [
	failure ifNotNil: [ ^ self ].
	self assert: (sorts at: aSymbol) equals: aSort.
	bound at: aSymbol ifPresent: [ :value |
		value = aTerm
			ifTrue: [ ^ self ]
			ifFalse: [ self failWith: aTerm notUnifiableWith: value ] ].
	unbound at: aSymbol
		ifPresent: [ :equalVars |
			self bindVarSet: equalVars to: aTerm ]
		ifAbsent: [
			self failUnless: aTerm sort isSubsortOf: aSort.
			bound at: aSymbol put: aTerm ]
]

{ #category : #binding }
LzBindingsObsolete >> bindVarSet: aSet to: aTerm [
	self failUnless: aTerm sort isSubsortOf: (sorts at: aSet).
	sorts removeKey: aSet.
	aSet do: [ :eachVarName |
		bound at: eachVarName put: aTerm.
		unbound removeKey: eachVarName ]
]

{ #category : #accessing }
LzBindingsObsolete >> bindingFor: aName [
	bound at: aName
		ifPresent: [ :value | ^ value ].
	^ nil
]

{ #category : #accessing }
LzBindingsObsolete >> bindings [
	^ bound
]

{ #category : #binding }
LzBindingsObsolete >> combineWith: otherBindings [
	otherBindings bindings associationsDo: [ :each |
		| var sort binding |
		var := each key.
		binding := each value.
		sort := otherBindings sortOf: var.
		self defineVar: var sort: sort.
		self bindVar: var sort: sort to: binding. ].
	otherBindings unboundVarSets do: [ :eachVarSet |
		| varsAndSorts |
		varsAndSorts := eachVarSet asArray collect: [ :eachVar |
			{ eachVar. otherBindings sortOf: eachVar } ].
		varsAndSorts do: [ :each |
			self defineVar: each first sort: each second ].
		varsAndSorts overlappingPairsDo: [ :a :b |
			self
				makeVar: a first sort: a second
				equalToVar: b first sort: b second ] ]
]

{ #category : #binding }
LzBindingsObsolete >> defineVar: aVarName sort: aSort [
	| varSet |
	sorts at: aVarName
		ifPresent: [ :sort | self assert: sort equals: aSort ]
		ifAbsentPut: [ aSort ].
	bound at: aVarName ifPresent: [ ^ self ].
	unbound at: aVarName ifPresent: [ ^ self ].
	varSet := Set with: aVarName.
	unbound at: aVarName put: varSet.
	sorts at: varSet put: aSort	
]

{ #category : #failing }
LzBindingsObsolete >> failUnless: aSort isSubsortOf: otherSort [
	failure ifNil: [
		aSort <= otherSort ifFalse: [
			failure := { #notSubsort. aSort. otherSort } ] ]
]

{ #category : #failing }
LzBindingsObsolete >> failWith: aSort incommensurableWith: otherSort [
	failure ifNil: [
		failure := { #incommensurableSorts. aSort. otherSort } ]
]

{ #category : #failing }
LzBindingsObsolete >> failWith: aTerm notUnifiableWith: otherTerm [
	failure ifNil: [
		failure := { #nonUnifiableTerms. aTerm. otherTerm } ]
]

{ #category : #inspecting }
LzBindingsObsolete >> gtBindingsFor: aView [
	<gtView>
	bound ifEmpty: [ ^ aView empty ].
	^ aView columnedList
		title: 'Bindings';
		priority: 1;
		items: [ bound keys ];
		column: 'Name' text: #asSymbol;
		column: 'Sort' text: [ :each | (sorts at: each) asLeibnizSyntaxString ];
		column: 'Value' text: [ :each | (bound at: each) asLeibnizSyntaxString ];
		yourself
]

{ #category : #inspecting }
LzBindingsObsolete >> gtFailureFor: aView [
	<gtView>
	failure ifNil: [ ^ aView empty ].
	^ aView list
		title: 'Failure';
		priority: 0;
		items: [ { failure first.
					failure second asLeibnizSyntax.
					failure third asLeibnizSyntax } ];
		yourself
]

{ #category : #inspecting }
LzBindingsObsolete >> gtUnboundFor: aView [
	<gtView>
	unbound ifEmpty: [ ^ aView empty ].
	^ aView columnedList
		title: 'Unbound';
		priority: 2;
		items: [ unbound values asSet asArray ];
		column: 'Names' text: [ :each |
			' = ' join: (each collect: #asSymbol) ];
		column: 'Sort' text: [ :each |
			(sorts at: each) asLeibnizSyntaxString ];
		yourself
]

{ #category : #testing }
LzBindingsObsolete >> hasNoBindings [
	^ bound isEmpty
]

{ #category : #testing }
LzBindingsObsolete >> ifFailure: aBlock [
	^ failure
		ifNotNil: [ aBlock value ]
]

{ #category : #testing }
LzBindingsObsolete >> ifSuccess: aBlock [
	^ failure
		ifNil: [ aBlock cull: self ]
]

{ #category : #testing }
LzBindingsObsolete >> ifSuccess: block1 ifFailure: block2 [
	^ failure
		ifNil: [ block1 cull: self ]
		ifNotNil: [ block2 value ]
]

{ #category : #accessing }
LzBindingsObsolete >> initialize [
	bound := Dictionary new.
	unbound := Dictionary new.
	sorts := Dictionary new.
	failure := nil.
]

{ #category : #binding }
LzBindingsObsolete >> makeVar: aSymbol sort: aSort equalToVar: otherSymbol sort: otherSort [
	failure ifNotNil: [ ^ self ].
	aSymbol = otherSymbol ifTrue: [ ^ self ].
	self assert: (sorts at: aSymbol) equals: aSort.
	self assert: (sorts at: otherSymbol) equals: otherSort.
	bound at: aSymbol ifPresent: [ :value |
		self bindVar: otherSymbol sort: otherSort to: value.
		^ self ].
	bound at: otherSymbol ifPresent: [ :value |
		self bindVar: aSymbol sort: aSort to: value.
		^ self ].
	self mergeVarSetsFor: aSymbol and: otherSymbol
]

{ #category : #binding }
LzBindingsObsolete >> mergeVarSetsFor: aSymbol and: otherSymbol [
	| varSet1 varSet2 sort mergedVarSet |
	varSet1 := unbound at: aSymbol.
	(varSet1 includes: otherSymbol) ifTrue: [ ^ self ].
	varSet2 := unbound at: otherSymbol.
	sort := (sorts at: varSet1) min: (sorts at: varSet2).
	sort ifNil: [ self failWith:(sorts at: varSet1)
					incommensurableWith: (sorts at: varSet2) ].
	mergedVarSet := varSet1 union: varSet2.
	mergedVarSet do: [ :each |
		unbound at: each put: mergedVarSet ].
	sorts at: mergedVarSet put: sort.
	sorts removeKey: varSet1.
	sorts removeKey: varSet2.
]

{ #category : #printing }
LzBindingsObsolete >> printBoundOn: aStream [
	bound keys sorted
		do: [ :each | 
			aStream nextPutAll: each asString.
			aStream nextPut: $=.
			(bound at: each) printAsLeibnizSyntaxOn: aStream ]
		separatedBy: [ aStream nextPutAll: ', ' ]
]

{ #category : #printing }
LzBindingsObsolete >> printFailureOn: aStream [
	aStream nextPutAll: 'failure #'.
	aStream nextPutAll: failure first.
	aStream nextPutAll: ': '.
	failure allButFirst do: [ :each |
		each printAsLeibnizSyntaxOn: aStream. ]
		separatedBy: [ aStream nextPutAll: ', ' ]
]

{ #category : #printing }
LzBindingsObsolete >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	failure ifNil: [
		self printUnboundOn: aStream.
		unbound ifNotEmpty: [
			bound ifNotEmpty: [ aStream nextPutAll: ', ' ] ].
		self printBoundOn: aStream ]
		ifNotNil: [ self printFailureOn: aStream ].
	aStream nextPut: $)
]

{ #category : #printing }
LzBindingsObsolete >> printUnboundOn: aStream [
	| varSets |
	varSets := unbound values asSet asArray
				collect: [ :each | each asArray sorted ].
	varSets sort: [ :a :b | a first <= b first ].
	varSets do: [ :eachVarSet | 
		eachVarSet asArray sorted
			do: [ :eachVarName | aStream nextPutAll: eachVarName asString ]
			separatedBy: [ aStream nextPut: $= ] ]
		separatedBy: [ aStream nextPutAll: ', ' ]
]

{ #category : #accessing }
LzBindingsObsolete >> sortOf: aVarNameOrVarSet [
	^ sorts at: aVarNameOrVarSet
]

{ #category : #accessing }
LzBindingsObsolete >> unboundVarSets [
	^ unbound values asSet
]

{ #category : #accessing }
LzBindingsObsolete >> valueSlots [
	^ #(failure bound unbound sorts)
]
