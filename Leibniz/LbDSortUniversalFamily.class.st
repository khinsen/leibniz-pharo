Class {
	#name : 'LbDSortUniversalFamily',
	#superclass : 'LbDSortFamily',
	#category : 'Leibniz-7-DependentSorts'
}

{ #category : 'converting' }
LbDSortUniversalFamily >> asLeibnizSyntaxString [
	^ '*'
]

{ #category : 'initialization' }
LbDSortUniversalFamily >> initializeWithSortGraph: aSortGraph [
	sortGraph := aSortGraph
]

{ #category : 'printing' }
LbDSortUniversalFamily >> printOn: aStream [
	super printOn: aStream
]
