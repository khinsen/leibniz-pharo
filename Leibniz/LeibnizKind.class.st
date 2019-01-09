"
I represent a kind, which is a connected component of a sort graph.
"
Class {
	#name : #LeibnizKind,
	#superclass : #Object,
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'sortGraph',
		'sorts',
		'maximalSorts'
	],
	#category : #'Leibniz-Core'
}

{ #category : #'instance creation' }
LeibnizKind class >> sortGraph: aSortGraph sorts: setOfSorts maximalSorts: setOfMaximalSorts [
	^self basicNew
			initializeWithSortGraph: aSortGraph sorts: setOfSorts maximalSorts: setOfMaximalSorts;
			yourself

]

{ #category : #converting }
LeibnizKind >> asSet [
   ^ sorts

]

{ #category : #private }
LeibnizKind >> equalityTestWith: otherSorts [ 
	^ sorts = otherSorts

]

{ #category : #testing }
LeibnizKind >> includes: aSort [
	^ sorts includes: aSort

]

{ #category : #initialization }
LeibnizKind >> initializeWithSortGraph: aSortGraph sorts: setOfSorts maximalSorts: setOfMaximalSorts [
	sortGraph := aSortGraph.
	sorts := setOfSorts.
	maximalSorts := setOfMaximalSorts.

]

{ #category : #comparing }
LeibnizKind >> instVarsExcludedFromEquality [
	^#(#maximalSorts)

]

{ #category : #accessing }
LeibnizKind >> maximalSorts [
	^  maximalSorts
]

{ #category : #printing }
LeibnizKind >> printAsLeibnizSyntaxOn: aStream [
	aStream nextPut: $[.
	aStream nextPutAll: (', ' join: (maximalSorts collect: [ : sort | sort asString ])).
	aStream nextPut: $].

]

{ #category : #printing }
LeibnizKind >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	aStream nextPutAll: (', ' join: (self maximalSorts collect: [ : sort | sort asString ])).
	aStream nextPut: $).

]

{ #category : #accessing }
LeibnizKind >> size [
	^sorts size
]

{ #category : #accessing }
LeibnizKind >> sortGraph [
	^sortGraph

]
