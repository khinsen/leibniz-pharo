"
I represent a kind, which is a connected component of a sort graph.
"
Class {
	#name : #LeibnizKind,
	#superclass : #Object,
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

{ #category : #comparing }
LeibnizKind >> = aKind [
	"Equality test. Only one instance variable needs to be compared because
	 the values of the remaining ones are computed from this one."
	^ (aKind isKindOf: LeibnizKind) and: [aKind equalityTestWith: sorts].
]

{ #category : #converting }
LeibnizKind >> asSet [
   ^ sorts

]

{ #category : #private }
LeibnizKind >> equalityTestWith: otherSorts [ 
	^ sorts = otherSorts

]

{ #category : #comparing }
LeibnizKind >> hash [
	^ sorts hash
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

{ #category : #accessing }
LeibnizKind >> maximalSorts [
	^  maximalSorts
]

{ #category : #printing }
LeibnizKind >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	aStream nextPutAll: (', ' join: (self maximalSorts collect: [ : sort | sort asString ])).
	aStream nextPut: $).

]
