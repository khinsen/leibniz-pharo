Class {
	#name : 'LbVariables',
	#superclass : 'Object',
	#instVars : [
		'bound',
		'unbound',
		'failure',
		'sorts'
	],
	#category : 'Leibniz-3-Terms'
}

{ #category : 'api - binding' }
LbVariables >> bindToUniqueVar: aBlock [
	| varSetBindings |
	self isFailure ifTrue: [ ^ self ].
	varSetBindings := Dictionary new.
	unbound values asSet do: [ :each |
		varSetBindings at: each put: (aBlock value: each value: (sorts at: each)) ].
	varSetBindings keysAndValuesDo: [ :varSet :uniqueVarTerm |
		| aVar |
		aVar := varSet anyOne.
		self bindVar: aVar ofSort:(sorts at: aVar) to: uniqueVarTerm  ]	
]

{ #category : 'api - binding' }
LbVariables >> bindVar: aSymbol ofSort: aSort to: aTerm [
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

{ #category : 'binding' }
LbVariables >> bindVarSet: aSet to: aTerm [
	self failUnless: aTerm sort isSubsortOf: (sorts at: aSet).
	sorts removeKey: aSet.
	aSet do: [ :eachVarName |
		bound at: eachVarName put: aTerm.
		unbound removeKey: eachVarName ]
]

{ #category : 'lookup' }
LbVariables >> bindingFor: aName [
	bound at: aName
		ifPresent: [ :value | ^ value ].
	^ nil
]

{ #category : 'lookup' }
LbVariables >> bindings [
	^ bound
]

{ #category : 'api - binding' }
LbVariables >> defineVar: anLbOperatorName sort: aSort [
	| varSet |
	sorts at: anLbOperatorName
		ifPresent: [ :sort | self assert: sort equals: aSort ]
		ifAbsentPut: [ aSort ].
	bound at: anLbOperatorName ifPresent: [ ^ self ].
	unbound at: anLbOperatorName ifPresent: [ ^ self ].
	varSet := Set with: anLbOperatorName.
	unbound at: anLbOperatorName put: varSet.
	sorts at: varSet put: aSort	
]

{ #category : 'error handling' }
LbVariables >> failUnless: aSort isSubsortOf: anotherSort [
	failure ifNil: [
		aSort <= anotherSort ifFalse: [
			failure := { #notSubsort. aSort. anotherSort } ] ]
]

{ #category : 'error handling' }
LbVariables >> failWith: aSort incommensurableWith: anotherSort [
	failure ifNil: [ failure := { #incommensurableSorts. aSort. anotherSort } ]
]

{ #category : 'error handling' }
LbVariables >> failWith: aTerm notUnifiableWith: anotherTerm [
	failure ifNil: [ failure := { #nonUnifiableTerms. aTerm. anotherTerm } ]
]

{ #category : 'inspecting' }
LbVariables >> gtBindingsFor: aView [
	<gtView>
	bound ifEmpty: [ ^ aView empty ].
	^ aView columnedList
		title: 'Bindings';
		priority: 1;
		items: [ bound keys ];
		column: 'Name' lbCode: [ :each | each asSymbol ];
		column: 'Sort' lbCode: [ :each | (sorts at: each) asLeibnizSyntaxString ];
		column: 'Value' lbCode: [ :each | (bound at: each) asLeibnizSyntaxString ];
		yourself
]

{ #category : 'inspecting' }
LbVariables >> gtFailureFor: aView [
	<gtView>
	failure ifNil: [ ^ aView empty ].
	^ aView list
		title: 'Failure';
		priority: 0;
		items: [ { failure first. failure second asLeibnizSyntaxString. failure third asLeibnizSyntaxString } ];
		itemLbCode: [ :each | each ];
		yourself
]

{ #category : 'inspecting' }
LbVariables >> gtUnboundFor: aView [
	<gtView>
	unbound ifEmpty: [ ^ aView empty ].
	^ aView columnedList
		title: 'Unbound';
		priority: 2;
		items: [ unbound values asSet asArray ];
		column: 'Names' lbCode: [ :each |
			' = ' join: (each collect: #asSymbol) ];
		column: 'Sort' lbCode: [ :each |
			(sorts at: each) asLeibnizSyntaxString ];
		yourself
]

{ #category : 'testing' }
LbVariables >> hasNoBindings [
	^ bound isEmpty
]

{ #category : 'testing' }
LbVariables >> ifFailure: aBlock [
	^ failure
		ifNotNil: [ aBlock value ]
]

{ #category : 'testing' }
LbVariables >> ifSuccess: aBlock [
	^ failure
		ifNil: [ aBlock cull: self ]
]

{ #category : 'testing' }
LbVariables >> ifSuccess: block1 ifFailure: block2 [
	^ failure
		ifNil: [ block1 cull: self ]
		ifNotNil: [ block2 value ]
]

{ #category : 'initialization' }
LbVariables >> initialize [
	bound := Dictionary new.
	unbound := Dictionary new.
	sorts := Dictionary new.
	failure := nil.
]

{ #category : 'testing' }
LbVariables >> isFailure [
	^ failure isNotNil
]

{ #category : 'api - binding' }
LbVariables >> makeVar: aSymbol ofSort: aSort equalToVar: anotherSymbol ofSort: anotherSort [
	failure ifNotNil: [ ^ self ].
	aSymbol = anotherSymbol ifTrue: [ ^ self ].
	self assert: (sorts at: aSymbol) equals: aSort.
	self assert: (sorts at: anotherSymbol) equals: anotherSort.
	bound at: aSymbol ifPresent: [ :value |
		self bindVar: anotherSymbol ofSort: anotherSort to: value.
		^ self ].
	bound at: anotherSymbol ifPresent: [ :value |
		self bindVar: aSymbol ofSort: aSort to: value.
		^ self ].
	self mergeVarSetsFor: aSymbol and: anotherSymbol
]

{ #category : 'binding' }
LbVariables >> mergeVarSetsFor: aSymbol and: anotherSymbol [
	| varSet1 varSet2 sort mergedVarSet |
	varSet1 := unbound at: aSymbol.
	(varSet1 includes: anotherSymbol) ifTrue: [ ^ self ].
	varSet2 := unbound at: anotherSymbol.
	sort := (sorts at: varSet1) min: (sorts at: varSet2).
	sort ifNil: [ self failWith:(sorts at: varSet1) incommensurableWith: (sorts at: varSet2) ].
	mergedVarSet := varSet1 union: varSet2.
	mergedVarSet do: [ :each |
		unbound at: each put: mergedVarSet ].
	sorts at: mergedVarSet put: sort.
	sorts removeKey: varSet1.
	sorts removeKey: varSet2.
]

{ #category : 'printing' }
LbVariables >> printBoundOn: aStream [
	bound keys sorted
		do: [ :each | 
			aStream nextPutAll: each asString.
			aStream nextPut: $=.
			(bound at: each) printAsLeibnizSyntaxOn: aStream ]
		separatedBy: [ aStream nextPutAll: ', ' ]
]

{ #category : 'printing' }
LbVariables >> printFailureOn: aStream [
	aStream nextPutAll: 'failure #'.
	aStream nextPutAll: failure first.
	aStream nextPutAll: ': '.
	failure allButFirst do: [ :each |
		each printAsLeibnizSyntaxOn: aStream. ]
		separatedBy: [ aStream nextPutAll: ', ' ]
]

{ #category : 'printing' }
LbVariables >> printOn: aStream [
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

{ #category : 'printing' }
LbVariables >> printUnboundOn: aStream [
	| varSets |
	varSets := unbound values asSet asArray collect: [ :each | each asArray sorted ].
	varSets sort: [ :a :b | a first <= b first ].
	varSets do: [ :eachVarSet | 
		eachVarSet asArray sorted
			do: [ :eachVarName | aStream nextPutAll: eachVarName asString ]
			separatedBy: [ aStream nextPut: $= ] ]
		separatedBy: [ aStream nextPutAll: ', ' ]
]
