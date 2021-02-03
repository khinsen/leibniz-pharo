Class {
	#name : #LbDependentSortSpecificFamily,
	#superclass : #LbDependentSortFamily,
	#category : #'Leibniz-7-DependentSorts'
}

{ #category : #converting }
LbDependentSortSpecificFamily >> asLeibnizSyntaxString [
	^ String streamContents: [ :s | opName printForArity: argSorts on: s ]
]

{ #category : #initialization }
LbDependentSortSpecificFamily >> initializeWithSortGraph: aSortGraph sortOp: anLbOperator [
	self assert: anLbOperator size equals: 1.
	sortGraph := aSortGraph.
	opName := anLbOperator name.
	anLbOperator withRanksDo: [ :arity :sort | argSorts := arity ]
]

{ #category : #printing }
LbDependentSortSpecificFamily >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	opName printForArity: argSorts on: aStream.
	aStream nextPut: $)
]
