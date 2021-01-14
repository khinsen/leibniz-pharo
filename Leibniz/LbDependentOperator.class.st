Class {
	#name : #LbDependentOperator,
	#superclass : #Object,
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'name',
		'numArgs',
		'sortGraph',
		'ranks'
	],
	#category : #'Leibniz-7-DependentSorts'
}

{ #category : #'instance creation' }
LbDependentOperator class >> name: anOpName numArgs: anInteger sortGraph: aSortGraph [
	^ self basicNew
			initializeWithName: anOpName numArgs: anInteger sortGraph: aSortGraph;
			yourself
]

{ #category : #adding }
LbDependentOperator >> addArity: arity withSort: aSortTerm [
	ranks at: arity ifAbsentPut: [ aSortTerm ].
	(ranks at: arity) = aSortTerm
		ifFalse: [ self error: 'Conflicting earlier declaration with sort ',  (ranks at: arity) asLeibnizSyntaxString ]
]

{ #category : #inspecting }
LbDependentOperator >> gtRanksFor: aView [
	<gtView>
	ranks ifEmpty: [ ^ aView empty ].
	^ aView list
		title: 'Ranks';
		priority: 0;
		items: [ ranks associations ];
		itemLbCode: [ :each |
			(String streamContents:
				[ :s | self name printForArity: each key withSort: each value on: s ] )
			asRopedText ];
		yourself
]

{ #category : #initialization }
LbDependentOperator >> initializeWithName: anOpName numArgs: anInteger sortGraph: aSortGraph [
	name := anOpName.
	numArgs := anInteger.
	sortGraph := aSortGraph.
	ranks := Dictionary new.
]

{ #category : #accessing }
LbDependentOperator >> name [
	^ name
]

{ #category : #accessing }
LbDependentOperator >> numArgs [
	^ numArgs
]

{ #category : #printing }
LbDependentOperator >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	aStream nextPutAll: name asSymbol.
	aStream nextPutAll: '('.
	numArgs > 1 ifTrue: [
		(numArgs - 1) timesRepeat: [ aStream nextPutAll: '•, ' ] ].
	numArgs > 0 ifTrue: [ aStream nextPut: $• ].
	aStream nextPutAll: '), '.
	ranks size printOn: aStream.
	aStream nextPutAll: ' rank(s)'.
	aStream nextPut: $)
]

{ #category : #lookup }
LbDependentOperator >> ranksMatchingArgSorts: aSortArray [
	| matches |
	matches := OrderedCollection new.
	ranks associationsDo: [ :each |
		| match |
		match := LbSubstitution new.
		each key with: aSortArray do: [ :patternArg :valueArg |
			| submatches |
			submatches := patternArg matchAllSupersortsOf: valueArg.
			submatches
				ifEmpty: [ match makeNull ]
				ifNotEmpty: [
					submatches size > 1
						ifTrue: [ self error: 'Multiple matches not yet implemented'].
					match combineWith: submatches anyOne ] ].
		match ifNotNull: [
			matches add: (each key collect: [ :s | s substitute: match ])
							-> (each value substituteAndReduce: match) ] ].
	^ matches
]

{ #category : #accessing }
LbDependentOperator >> size [
	^ ranks size
]

{ #category : #lookup }
LbDependentOperator >> sortForArgSorts: aSortArray [
	| matches |
	matches := self ranksMatchingArgSorts: aSortArray.
	self assert: matches size equals: 1.
	^ matches first value
]
