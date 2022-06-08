Class {
	#name : #LbDKind,
	#superclass : #Object,
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'sortGraph',
		'sortFamilies',
		'maximalSortFamilies'
	],
	#category : 'Leibniz-7-DependentSorts'
}

{ #category : #'instance creation' }
LbDKind class >> sortGraph: aSortGraph sortFamilies: sortFamilies maximalSortFamilies: maximalSortFamilies [
	^ self basicNew
		initializeWithSortGraph: aSortGraph sortFamilies: sortFamilies maximalSortFamilies: maximalSortFamilies;
		yourself
]

{ #category : #converting }
LbDKind >> asLeibnizSyntaxString [
	^ String streamContents: [ :s | self printAsLeibnizSyntaxOn: s ]
]

{ #category : #converting }
LbDKind >> asSet [
	^ sortFamilies
]

{ #category : #inspecting }
LbDKind >> gtGraphFor: aView [
	<gtView>
	^ sortGraph
		graphFor: aView
		restrictedTo: sortFamilies
		highlight: [ false ]
]

{ #category : #testing }
LbDKind >> includes: aSort [
	^ sortFamilies includes: aSort family
]

{ #category : #initialization }
LbDKind >> initializeWithSortGraph: aSortGraph sortFamilies: sortFamilySet maximalSortFamilies: maximalSortFamilySet [
	sortGraph := aSortGraph.
	sortFamilies := sortFamilySet.
	maximalSortFamilies := maximalSortFamilySet.
	self beRecursivelyReadOnlyObject.
]

{ #category : #comparing }
LbDKind >> instVarsExcludedFromEquality [
	^#(maximalSortFamilies)
]

{ #category : #accessing }
LbDKind >> kind [
	^ self
]

{ #category : #accessing }
LbDKind >> maximalSortFamilies [
	^ maximalSortFamilies
]

{ #category : #printing }
LbDKind >> printAsLeibnizSyntaxOn: aStream [
	aStream nextPut: $[.
	aStream nextPutAll: (', ' join: (maximalSortFamilies collect: [ : sort | sort asLeibnizSyntaxString ])).
	aStream nextPut: $]
]

{ #category : #printing }
LbDKind >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	aStream nextPutAll: (', ' join: (self maximalSortFamilies collect: [ : sort | sort asLeibnizSyntaxString ])).
	aStream nextPut: $).
]

{ #category : #accessing }
LbDKind >> sortGraph [
	^ sortGraph
]
