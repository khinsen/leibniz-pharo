"
!! Kinds

Kinds are the connected components in a ${class:name=LeibnizSortGraph}$. They are not explicitly declared, but are the result of an analysis of subsort relations.
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
	#category : #'Leibniz-1-SortGraphs'
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

{ #category : #inspecting }
LeibnizKind >> childrenInInspector [
	^Array new
]

{ #category : #private }
LeibnizKind >> equalityTestWith: otherSorts [ 
	^ sorts = otherSorts

]

{ #category : #inspecting }
LeibnizKind >> gtInspectorNetworkViewIn: composite [
	<gtInspectorPresentationOrder: -10>
	composite roassal2
		title: 'Network View';
		initializeView: (sortGraph networkViewForSubset: sorts)


]

{ #category : #inspecting }
LeibnizKind >> gtInspectorTreeViewIn: composite [
	<gtInspectorPresentationOrder: -11>
	composite roassal2
		title: 'Tree View';
		initializeView: (sortGraph treeViewForSubset: sorts)

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

{ #category : #inspecting }
LeibnizKind >> title [
	^', ' join: (self maximalSorts collect: [ : sort | sort asString ])
]
