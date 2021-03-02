Class {
	#name : #LbDependentSortFamily,
	#superclass : #Object,
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'opName',
		'argSorts',
		'sortGraph'
	],
	#category : #'Leibniz-7-DependentSorts'
}

{ #category : #'instance creation' }
LbDependentSortFamily class >> anySortInSortGraph: aSortGraph [
	^ LbDependentSortUniversalFamily basicNew
		initializeWithSortGraph: aSortGraph;
		yourself
]

{ #category : #'instance creation' }
LbDependentSortFamily class >> sortGraph: aSortGraph sortOp: anLbOperator [
	^ LbDependentSortSpecificFamily basicNew
		initializeWithSortGraph: aSortGraph sortOp: anLbOperator;
		yourself
]

{ #category : #converting }
LbDependentSortFamily >> asLeibnizSyntaxString [
	self subclassResponsibility
]

{ #category : #inspecting }
LbDependentSortFamily >> gtGraphFor: aView [
	<gtView>
	| kind |
	kind := self kindFamily.
	^ sortGraph
		graphFor: aView
		restrictedTo: kind asSet
		highlight: [ :sort | sort = self ]
]

{ #category : #lookup }
LbDependentSortFamily >> kindFamily [
	^ sortGraph kindOf: self
]
