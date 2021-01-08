Class {
	#name : #LbDependentSignature,
	#superclass : #Object,
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'sortGraph',
		'variables',
		'operators'
	],
	#category : #'Leibniz-7-DependentSorts'
}

{ #category : #'instace creation' }
LbDependentSignature class >> sortGraph: aSortGraph operators: operatorDictionary variables: variableDictionary [
	^ self basicNew
		initializeWithSortGraph: aSortGraph
		operators: operatorDictionary
		variables: variableDictionary;
		yourself
]

{ #category : #copying }
LbDependentSignature >> copy [
	^ self
]

{ #category : #copying }
LbDependentSignature >> deepCopy [
	^ self
]

{ #category : #initialization }
LbDependentSignature >> initializeWithSortGraph: aSortGraph operators: operatorDictionary variables: variableDictionary [
	sortGraph := aSortGraph.
	operators := operatorDictionary.
	variables := variableDictionary.
	self beRecursivelyReadOnlyObject
]

{ #category : #'term construction' }
LbDependentSignature >> parseTerm: aString [
]
