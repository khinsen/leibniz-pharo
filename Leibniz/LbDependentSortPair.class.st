Class {
	#name : #LbDependentSortPair,
	#superclass : #Object,
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'sortGraph',
		'sort1',
		'sort2'
	],
	#category : #'Leibniz-7-DependentSorts'
}

{ #category : #'instance creation' }
LbDependentSortPair class >> sortGraph: aSortGraph sort1: sort1 sort2: sort2 [
	^ self basicNew
		initializeWithSortGraph: aSortGraph sort1: sort1 sort2: sort2;
		yourself
]

{ #category : #inspecting }
LbDependentSortPair >> gtSortsFor: aView [
	<gtView>
	^ aView list
		title: 'Sorts';
		priority: 0;
		items: [ { sort1. sort2 } ];
		yourself
]

{ #category : #initializing }
LbDependentSortPair >> initializeWithSortGraph: aSortGraph sort1: aSort sort2: anotherSort [
	sortGraph := aSortGraph.
	sort1 := aSort.
	sort2 := anotherSort
]
