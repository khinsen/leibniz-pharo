Class {
	#name : #LbDSortSpecificFamily,
	#superclass : #LbDSortFamily,
	#category : 'Leibniz-7-DependentSorts'
}

{ #category : #converting }
LbDSortSpecificFamily >> asLeibnizSyntaxString [
	^ String streamContents: [ :s | opName printForArity: argSorts on: s ]
]

{ #category : #initialization }
LbDSortSpecificFamily >> initializeWithSortGraph: aSortGraph sortOp: anLbOperator [
	self assert: anLbOperator size equals: 1.
	sortGraph := aSortGraph.
	opName := anLbOperator name.
	anLbOperator withRanksDo: [ :arity :sort | argSorts := arity ]
]

{ #category : #printing }
LbDSortSpecificFamily >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	opName printForArity: argSorts on: aStream.
	aStream nextPut: $)
]
