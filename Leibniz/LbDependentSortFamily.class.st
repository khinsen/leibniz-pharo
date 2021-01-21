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
LbDependentSortFamily class >> sortGraph: aSortGraph sortOp: anLbOperator [
	^ self basicNew
		initializeWithSortGraph: aSortGraph sortOp: anLbOperator;
		yourself
]

{ #category : #converting }
LbDependentSortFamily >> asLeibnizSyntaxString [
	^ String streamContents: [ :s | opName printForArity: argSorts on: s ]
]

{ #category : #inspecting }
LbDependentSortFamily >> gtGraphFor: aView [
	<gtView>
	| kind |
	kind := self kind.
	^ sortGraph graphFor: aView restrictedTo: kind asSet highlight: self
]

{ #category : #initialization }
LbDependentSortFamily >> initializeWithSortGraph: aSortGraph sortOp: anLbOperator [
	self assert: anLbOperator size equals: 1.
	sortGraph := aSortGraph.
	opName := anLbOperator name.
	anLbOperator withRanksDo: [ :arity :sort | argSorts := arity ]
]

{ #category : #lookup }
LbDependentSortFamily >> kind [
	^ sortGraph kindOf: self
]

{ #category : #printing }
LbDependentSortFamily >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	opName printForArity: argSorts on: aStream.
	aStream nextPut: $)
]
