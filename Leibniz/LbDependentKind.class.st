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
LbDependentKind class >> sortGraph: aSortGraph sorts: sorts maximalSorts: maximalSorts [
	^ self basicNew
		initializeWithSortGraph: aSortGraph sorts: sorts maximalSorts: maximalSorts;
		yourself
]

{ #category : #inspecting }
LbDependentKind >> gtGraphFor: aView [
	<gtView>
	^ sortGraph graphFor: aView restrictedTo: sortFamilies
]

{ #category : #initialization }
LbDependentKind >> initializeWithSortGraph: aSortGraph sorts: sortSet maximalSorts: maximalSortSet [
	sortGraph := aSortGraph.
	sortFamilies := sortSet.
	maximalSortFamilies := maximalSortSet.
	self beRecursivelyReadOnlyObject.
]

{ #category : #accessing }
LbDependentKind >> maximalSorts [
	^ maximalSortFamilies
]

{ #category : #printing }
LbDependentKind >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	aStream nextPutAll: (', ' join: (self maximalSorts collect: [ : sort | sort asLeibnizSyntaxString ])).
	aStream nextPut: $).
]
