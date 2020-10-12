"
!! Kinds

Kinds are the connected components in a ${class:name=LbSortGraph}$. They are not explicitly declared, but are the result of an analysis of subsort relations.
"
Class {
	#name : #LbKind,
	#superclass : #Object,
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'sortGraph',
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
   ^ sorts

]

{ #category : #inspecting }
LbKind >> childrenInInspector [
	^Array new
]

{ #category : #private }
LbKind >> equalityTestWith: otherSorts [ 
	^ sorts = otherSorts

]

{ #category : #inspecting }
LbKind >> gtInspectorNetworkViewIn: composite [
	<gtInspectorPresentationOrder: -10>
	composite roassal2
		title: 'Network View';
		initializeView: (sortGraph networkViewForSubset: sorts)


]

{ #category : #inspecting }
LbKind >> gtInspectorTreeViewIn: composite [
	<gtInspectorPresentationOrder: -11>
	composite roassal2
		title: 'Tree View';
		initializeView: (sortGraph treeViewForSubset: sorts)

]

{ #category : #testing }
LbKind >> includes: aSort [
	^ sorts includes: aSort

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
LbKind >> maximalSorts [
	^  maximalSorts
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
	aStream nextPutAll: (', ' join: (self maximalSorts collect: [ : sort | sort asString ])).
	aStream nextPut: $).

]

{ #category : #accessing }
LbKind >> size [
	^sorts size
]

{ #category : #accessing }
LbKind >> sortGraph [
	^sortGraph

]

{ #category : #inspecting }
LbKind >> title [
	^', ' join: (self maximalSorts collect: [ : sort | sort asString ])
]
