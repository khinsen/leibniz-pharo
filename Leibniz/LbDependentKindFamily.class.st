Class {
	#name : #LbDependentKindFamily,
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
LbDependentKindFamily class >> sortGraph: aSortGraph sortFamilies: sortFamilies maximalSortFamilies: maximalSortFamilies [
	^ self basicNew
		initializeWithSortGraph: aSortGraph sortFamilies: sortFamilies maximalSortFamilies: maximalSortFamilies;
		yourself
]

{ #category : #converting }
LbDependentKindFamily >> asLeibnizSyntaxString [
	^ String streamContents: [ :s | self printAsLeibnizSyntaxOn: s ]
]

{ #category : #converting }
LbDependentKindFamily >> asSet [
	^ sortFamilies
]

{ #category : #inspecting }
LbDependentKindFamily >> gtGraphFor: aView [
	<gtView>
	^ sortGraph graphFor: aView restrictedTo: sortFamilies highlight: nil
]

{ #category : #initialization }
LbDependentKindFamily >> initializeWithSortGraph: aSortGraph sortFamilies: sortFamilySet maximalSortFamilies: maximalSortFamilySet [
	sortGraph := aSortGraph.
	sortFamilies := sortFamilySet.
	maximalSortFamilies := maximalSortFamilySet.
	self beRecursivelyReadOnlyObject.
]

{ #category : #comparing }
LbDependentKindFamily >> instVarsExcludedFromEquality [
	^#(maximalSortFamilies)
]

{ #category : #accessing }
LbDependentKindFamily >> kindFamily [
	^ self
]

{ #category : #accessing }
LbDependentKindFamily >> maximalSortFamilies [
	^ maximalSortFamilies
]

{ #category : #printing }
LbDependentKindFamily >> printAsLeibnizSyntaxOn: aStream [
	aStream nextPut: $[.
	aStream nextPutAll: (', ' join: (maximalSortFamilies collect: [ : sort | sort asLeibnizSyntaxString ])).
	aStream nextPut: $]
]

{ #category : #printing }
LbDependentKindFamily >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	aStream nextPutAll: (', ' join: (self maximalSortFamilies collect: [ : sort | sort asLeibnizSyntaxString ])).
	aStream nextPut: $).
]

{ #category : #accessing }
LbDependentKindFamily >> sortGraph [
	^ sortGraph
]
