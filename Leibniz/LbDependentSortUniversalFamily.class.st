Class {
	#name : 'LbDependentSortUniversalFamily',
	#superclass : 'LbDependentSortFamily',
	#category : 'Leibniz-7-DependentSorts'
}

{ #category : 'converting' }
LbDependentSortUniversalFamily >> asLeibnizSyntaxString [
	^ '*'
]

{ #category : 'initialization' }
LbDependentSortUniversalFamily >> initializeWithSortGraph: aSortGraph [
	sortGraph := aSortGraph
]

{ #category : 'printing' }
LbDependentSortUniversalFamily >> printOn: aStream [
	super printOn: aStream
]
