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

{ #category : #initializing }
LeibnizSignature >> initializeWithSortGraph: aSortGraph operators: anOperatorDictionary variables: aVariableDictionary [
	sortGraph := aSortGraph.
	operators := anOperatorDictionary.
	variables := aVariableDictionary.
	self beRecursivelyReadOnlyObject.

]
