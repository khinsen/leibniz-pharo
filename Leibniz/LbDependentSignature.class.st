Class {
	#name : #LbDependentSignature,
	#superclass : #Object,
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'sortGraph'
	],
	#category : #'Leibniz-7-DependentSorts'
}

{ #category : #'instace creation' }
LbDependentSignature class >> sortGraph: aSortGraph [
	^ self basicNew
		initializeWithSortGraph: aSortGraph;
		yourself
]

{ #category : #initialization }
LbDependentSignature >> initializeWithSortGraph: aSortGraph [
	sortGraph := aSortGraph.
	self beRecursivelyReadOnlyObject
]

{ #category : #'term construction' }
LbDependentSignature >> parseTerm: aString [
]
