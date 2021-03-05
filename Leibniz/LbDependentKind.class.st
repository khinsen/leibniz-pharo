Class {
	#name : #LbDependentKind,
	#superclass : #Object,
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'sortGraph',
		'sortFamilies',
		'maximalSortFamilies'
	],
	#category : #'Leibniz-7-DependentSorts'
}

{ #category : #'instance creation' }
LbDependentKind class >> sortGraph: aSortGraph sortFamilies: sortFamilies maximalSortFamilies: maximalSortFamilies [
	^ self basicNew
		initializeWithSortGraph: aSortGraph sortFamilies: sortFamilies maximalSortFamilies: maximalSortFamilies;
		yourself
]

{ #category : #converting }
LbDependentKind >> asLeibnizSyntaxString [
	^ String streamContents: [ :s | self printAsLeibnizSyntaxOn: s ]
]

{ #category : #converting }
LbDependentKind >> asSet [
	^ sortFamilies
]

{ #category : #inspecting }
LbDependentKind >> gtGraphFor: aView [
	<gtView>
	^ sortGraph
		graphFor: aView
		restrictedTo: sortFamilies
		highlight: [ false ]
]

{ #category : #initialization }
LbDependentKind >> initializeWithSortGraph: aSortGraph sortFamilies: sortFamilySet maximalSortFamilies: maximalSortFamilySet [
	sortGraph := aSortGraph.
	sortFamilies := sortFamilySet.
	maximalSortFamilies := maximalSortFamilySet.
	self beRecursivelyReadOnlyObject.
]

{ #category : #comparing }
LbDependentKind >> instVarsExcludedFromEquality [
	^#(maximalSortFamilies)
]

{ #category : #accessing }
LbDependentKind >> kind [
	^ self
]

{ #category : #accessing }
LbDependentKind >> maximalSortFamilies [
	^ maximalSortFamilies
]

{ #category : #printing }
LbDependentKind >> printAsLeibnizSyntaxOn: aStream [
	aStream nextPut: $[.
	aStream nextPutAll: (', ' join: (maximalSortFamilies collect: [ : sort | sort asLeibnizSyntaxString ])).
	aStream nextPut: $]
]

{ #category : #printing }
LbDependentKind >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	aStream nextPutAll: (', ' join: (self maximalSortFamilies collect: [ : sort | sort asLeibnizSyntaxString ])).
	aStream nextPut: $).
]

{ #category : #accessing }
LbDependentKind >> sortGraph [
	^ sortGraph
]
