"
I represent the signature of a Leibniz context.
"
Class {
	#name : #LeibnizSignature,
	#superclass : #Object,
	#instVars : [
		'sortGraph',
		'operators',
		'variables'
	],
	#category : #'Leibniz-Core'
}

{ #category : #'instance creation' }
LeibnizSignature class >> sortGraph: aSortGraph operators: anOperatorDictionary variables: aVariableDictionary [
	^ self basicNew
			 initializeWithSortGraph: aSortGraph
								operators: anOperatorDictionary
								variables: aVariableDictionary;
			 yourself.

]

{ #category : #copying }
LeibnizSignature >> copy [
	^self
]

{ #category : #copying }
LeibnizSignature >> deepCopy [
	^self
]

{ #category : #initializing }
LeibnizSignature >> initializeWithSortGraph: aSortGraph operators: anOperatorDictionary variables: aVariableDictionary [
	sortGraph := aSortGraph.
	operators := anOperatorDictionary.
	variables := aVariableDictionary.
	self beRecursivelyReadOnlyObject.

]

{ #category : #accessing }
LeibnizSignature >> operators [
	^operators
]

{ #category : #accessing }
LeibnizSignature >> variables [
	^variables
]
