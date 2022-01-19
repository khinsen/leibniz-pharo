Class {
	#name : #LzBindings,
	#superclass : #Object,
	#instVars : [
		'sorts',
		'bound',
		'unbound',
		'failure'
	],
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #binding }
LzBindings >> bindVar: aSymbol sort: aSort to: aTerm [
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
LzBindings >> bindVarSet: aSet to: aTerm [
	self failUnless: aTerm sort isSubsortOf: (sorts at: aSet).
	sorts removeKey: aSet.
	aSet do: [ :eachVarName |
		bound at: eachVarName put: aTerm.
		unbound removeKey: eachVarName ]
]

{ #category : #accessing }
LzBindings >> bindingFor: aName [
	bound at: aName
		ifPresent: [ :value | ^ value ].
	^ nil
]

{ #category : #accessing }
LzBindings >> bindings [
	^ bound
]

{ #category : #binding }
LzBindings >> defineVar: aVarName sort: aSort [
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

{ #category : #inspecting }
LzBindings >> gtBindingsFor: aView [
	<gtView>
	bound ifEmpty: [ ^ aView empty ].
	^ aView columnedList
		title: 'Bindings';
		priority: 1;
		items: [ bound keys ];
		column: 'Name' lzCode: #asSymbol;
		column: 'Sort' lzCode: [ :each | (sorts at: each) asLeibnizSyntaxString ];
		column: 'Value' lzCode: [ :each | (bound at: each) asLeibnizSyntaxString ];
		yourself
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
	unbound ifEmpty: [ ^ aView empty ].
	^ aView columnedList
		title: 'Unbound';
		priority: 2;
		items: [ unbound values asSet asArray ];
		column: 'Names' lzCode: [ :each |
			' = ' join: (each collect: #asSymbol) ];
		column: 'Sort' lzCode: [ :each |
			(sorts at: each) asLeibnizSyntaxString ];
		yourself
]

{ #category : #accessing }
LzBindings >> initialize [
	bound := Dictionary new.
	unbound := Dictionary new.
	sorts := Dictionary new.
	failure := nil.
]

{ #category : #printing }
LzBindings >> printBoundOn: aStream [
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
	failure ifNil: [
		self printUnboundOn: aStream.
		unbound ifNotEmpty: [
			bound ifNotEmpty: [ aStream nextPutAll: ', ' ] ].
		self printBoundOn: aStream ]
		ifNotNil: [ self printFailureOn: aStream ].
	aStream nextPut: $)
]

{ #category : #printing }
LzBindings >> printUnboundOn: aStream [
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
