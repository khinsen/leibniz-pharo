Class {
	#name : 'LbDSortFamily',
	#superclass : 'Object',
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'opName',
		'argSorts',
		'sortGraph'
	],
	#category : 'Leibniz-7-DependentSorts'
}

{ #category : 'instance creation' }
LbDSortFamily class >> anySortInSortGraph: aSortGraph [
	^ LbDSortUniversalFamily basicNew
		initializeWithSortGraph: aSortGraph;
		yourself
]

{ #category : 'instance creation' }
LbDSortFamily class >> sortGraph: aSortGraph sortOp: anLbOperator [
	^ LbDSortSpecificFamily basicNew
		initializeWithSortGraph: aSortGraph sortOp: anLbOperator;
		yourself
]

{ #category : 'converting' }
LbDSortFamily >> asLeibnizSyntaxString [
	self subclassResponsibility
]

{ #category : 'inspecting' }
LbDSortFamily >> gtGraphFor: aView [
	<gtView>
	| kind |
	kind := self kind.
	^ sortGraph
		graphFor: aView
		restrictedTo: kind asSet
		highlight: [ :sort | sort = self ]
]

{ #category : 'lookup' }
LbDSortFamily >> kind [
	^ sortGraph kindOf: self
]
