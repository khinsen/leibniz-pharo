Class {
	#name : #LbVariables,
	#superclass : #Object,
	#instVars : [
		'bound',
		'unbound',
		'failure',
		'sorts'
	],
	#category : #'Leibniz-3-Terms'
}

{ #category : #'api - binding' }
LbVariables >> bindVar: aSymbol ofSort: aSort to: aTerm [
	failure ifNotNil: [ ^ self ].
	self registerVar: aSymbol ofSort: aSort.
	bound at: aSymbol ifPresent: [ :value |
		value = aTerm
			ifTrue: [ ^ self ]
			ifFalse: [ self failWith: aTerm notEqualTo: value ] ].
	unbound at: aSymbol
		ifPresent: [ :equalVars |
			self bindVarSet: equalVars to: aTerm ]
		ifAbsent: [
			self failUnless: aTerm sort isSubsortOf: aSort.
			bound at: aSymbol put: aTerm ]
]

{ #category : #binding }
LbVariables >> bindVarSet: aSet to: aTerm [
	self failUnless: aTerm sort isSubsortOf: (sorts at: aSet).
	sorts removeKey: aSet.
	aSet do: [ :eachVarName |
		bound at: eachVarName put: aTerm.
		unbound removeAt: eachVarName ]
]

{ #category : #'error handling' }
LbVariables >> failUnless: aSort isSubsortOf: anotherSort [
	failure ifNil: [
		aSort <= anotherSort ifFalse: [
			failure := { #notSubsort. aSort. anotherSort } ] ]
]

{ #category : #'error handling' }
LbVariables >> failWith: aSort incommensurableWith: anotherSort [
	failure ifNil: [ failure := { #incommensurableSorts. aSort. anotherSort } ]
]

{ #category : #'error handling' }
LbVariables >> failWith: aTerm notEqualTo: anotherTerm [
	failure ifNil: [ failure := { #nonEqualTerms. aTerm. anotherTerm } ]
]

{ #category : #initialization }
LbVariables >> initialize [
	bound := Dictionary new.
	unbound := Dictionary new.
	sorts := Dictionary new.
	failure := nil.
]

{ #category : #'api - binding' }
LbVariables >> makeVar: aSymbol ofSort: aSort equalToVar: anotherSymbol ofSort: anotherSort [
	failure ifNotNil: [ ^ self ].
	aSymbol = anotherSymbol ifTrue: [ ^ self ].
	bound at: aSymbol ifPresent: [ :value |
		self bindVar: anotherSymbol ofSort: anotherSort to: value.
		^ self ].
	bound at: anotherSymbol ifPresent: [ :value |
		self bindVar: aSymbol ofSort: aSort to: value.
		^ self ].
	self registerUnboundVar: aSymbol ofSort: aSort.
	self registerUnboundVar: anotherSymbol ofSort: anotherSort.
	self mergeVarSetsFor: aSymbol and: anotherSymbol
]

{ #category : #binding }
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

{ #category : #printing }
LbVariables >> printBoundOn: aStream [
	bound keys sorted
		do: [ :each | 
			aStream nextPutAll: each asString.
			aStream nextPut: $=.
			(bound at: each) printAsLeibnizSyntaxOn: aStream ]
		separatedBy: [ aStream nextPutAll: ', ' ]
]

{ #category : #printing }
LbVariables >> printFailureOn: aStream [
	aStream nextPutAll: 'failure #'.
	aStream nextPutAll: failure first.
	aStream nextPutAll: ': '.
	failure allButFirst do: [ :each |
		each printAsLeibnizSyntaxOn: aStream. ]
		separatedBy: [ aStream nextPutAll: ', ' ]
]

{ #category : #printing }
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

{ #category : #printing }
LbVariables >> printUnboundOn: aStream [
	unbound values asSet
		do: [ :eachVarSet | 
			eachVarSet asArray sorted
				do: [ :eachVarName | aStream nextPutAll: eachVarName asString ]
				separatedBy: [ aStream nextPut: $= ] ]
		separatedBy: [ aStream nextPutAll: ', ' ]
]

{ #category : #binding }
LbVariables >> registerUnboundVar: aSymbol ofSort: aSort [
	| varSet |
	self registerVar: aSymbol ofSort: aSort.
	unbound at: aSymbol ifPresent: [ ^ self ].
	varSet := Set with: aSymbol.
	unbound at: aSymbol put: varSet.
	sorts at: varSet put: aSort
]

{ #category : #binding }
LbVariables >> registerVar: aSymbol ofSort: aSort [
	sorts at: aSymbol
		ifPresent: [ :sort | self assert: sort equals: aSort ]
		ifAbsentPut: [ aSort ]
]