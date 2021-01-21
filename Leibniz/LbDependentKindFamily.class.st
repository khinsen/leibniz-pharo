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
LbDependentKindFamily class >> sortGraph: aSortGraph sorts: sorts maximalSorts: maximalSorts [
	^ self basicNew
		initializeWithSortGraph: aSortGraph sorts: sorts maximalSorts: maximalSorts;
		yourself
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
LbDependentKindFamily >> initializeWithSortGraph: aSortGraph sorts: sortSet maximalSorts: maximalSortSet [
	sortGraph := aSortGraph.
	sortFamilies := sortSet.
	maximalSortFamilies := maximalSortSet.
	self beRecursivelyReadOnlyObject.
]

{ #category : #comparing }
LbDependentKindFamily >> instVarsExcludedFromEquality [
	^#(maximalSortFamilies)
]

{ #category : #accessing }
LbDependentKindFamily >> maximalSortFamilies [
	^ maximalSortFamilies
]

{ #category : #printing }
LbDependentKindFamily >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	aStream nextPutAll: (', ' join: (self maximalSortFamilies collect: [ : sort | sort asLeibnizSyntaxString ])).
	aStream nextPut: $).
]
