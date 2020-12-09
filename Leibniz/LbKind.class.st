"
!! Kinds

Kinds are the connected components in a ${class:name=LbSortGraph}$. They are not explicitly declared, but are the result of an analysis of subsort relations.
"
Class {
	#name : #LbKind,
	#superclass : #LbSortClassifier,
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'sorts',
		'maximalSorts'
	],
	#category : #'Leibniz-1-SortGraphs'
}

{ #category : #'instance creation' }
LbKind class >> sortGraph: aSortGraph sorts: setOfSorts maximalSorts: setOfMaximalSorts [
	^self basicNew
			initializeWithSortGraph: aSortGraph sorts: setOfSorts maximalSorts: setOfMaximalSorts;
			yourself

]

{ #category : #converting }
LbKind >> asSet [
   ^ sorts collect: [ :each | sortGraph sortNamed: each ]
]

{ #category : #private }
LbKind >> equalityTestWith: otherSorts [ 
	^ sorts = otherSorts
]

{ #category : #testing }
LbKind >> includes: aSort [
	^ sorts includes: aSort name
]

{ #category : #initialization }
LbKind >> initializeWithSortGraph: aSortGraph sorts: setOfSorts maximalSorts: setOfMaximalSorts [
	sortGraph := aSortGraph.
	sorts := setOfSorts.
	maximalSorts := setOfMaximalSorts.

]

{ #category : #comparing }
LbKind >> instVarsExcludedFromEquality [
	^#(#maximalSorts)

]

{ #category : #accessing }
LbKind >> kind [
	^ self
]

{ #category : #accessing }
LbKind >> maximalSorts [
	^  maximalSorts collect: [ :each | sortGraph sortNamed: each ]
]

{ #category : #printing }
LbKind >> printAsLeibnizSyntaxOn: aStream [
	aStream nextPut: $[.
	aStream nextPutAll: (', ' join: (maximalSorts collect: [ : sort | sort asString ])).
	aStream nextPut: $].

]

{ #category : #printing }
LbKind >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	aStream nextPutAll: (', ' join: (self maximalSorts collect: [ : sort | sort name asString ])).
	aStream nextPut: $).
]

{ #category : #'private - comparing' }
LbKind >> sortAfterKind: aKind [
	| msA msB |
	self size > aKind size ifTrue: [ ^ true ].
	msA := self maximalSorts asArray sorted: [ :a :b | a sortBefore: b ].
	msB := aKind maximalSorts asArray sorted: [ :a :b | a sortBefore: b ].
	msA size > msB size ifTrue: [ ^ true ].
	msA size < msB size ifTrue: [ ^ false ].
	msA with: msB do: [ :a :b | a <= b ifTrue: [ ^ false ] ].
	^ true
]

{ #category : #'private - comparing' }
LbKind >> sortAfterSort: aSort [
	^ true
]

{ #category : #comparing }
LbKind >> sortBefore: aSort [
	^ aSort sortAfterKind: self
]

{ #category : #inspecting }
LbKind >> title [
	^', ' join: (self maximalSorts collect: [ : sort | sort asString ])
]
