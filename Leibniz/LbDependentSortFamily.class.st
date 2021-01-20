Class {
	#name : #LbDependentSortFamily,
	#superclass : #Object,
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'opName',
		'argSorts'
	],
	#category : #'Leibniz-7-DependentSorts'
}

{ #category : #'instance creation' }
LbDependentSortFamily class >> sortOp: anLbOperator [
	^ self basicNew
		initializeWithSortOp: anLbOperator;
		yourself
]

{ #category : #converting }
LbDependentSortFamily >> asLeibnizSyntaxString [
	^ String streamContents: [ :s | opName printForArity: argSorts on: s ]
]

{ #category : #initialization }
LbDependentSortFamily >> initializeWithSortOp: anLbOperator [
	self assert: anLbOperator size equals: 1.
	opName := anLbOperator name.
	anLbOperator withRanksDo: [ :arity :sort | argSorts := arity ]
]

{ #category : #printing }
LbDependentSortFamily >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	opName printForArity: argSorts on: aStream.
	aStream nextPut: $)
]
