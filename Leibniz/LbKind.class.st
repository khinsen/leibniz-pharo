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

{ #category : #printing }
LbKind >> asLeibnizSyntaxString [
	^ String streamContents: [ :s | self printAsLeibnizSyntaxOn: s ]
]

{ #category : #converting }
LbKind >> asSet [
   ^ sorts collect: [ :each | sortGraph sortNamed: each ]
]

{ #category : #enumerating }
LbKind >> conformingSorts [
	^ self asSet
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

{ #category : #testing }
LbKind >> isConformingSort: aSort [
	^ self includes: aSort
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

{ #category : #inspecting }
LbKind >> title [
	^', ' join: (self maximalSorts collect: [ : sort | sort asString ])
]
