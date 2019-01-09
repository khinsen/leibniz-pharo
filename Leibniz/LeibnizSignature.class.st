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
LeibnizSignature >> numberOfOperators [
	^operators size
]

{ #category : #accessing }
LeibnizSignature >> numberOfVariables [
	^variables size
]

{ #category : #enumerating }
LeibnizSignature >> withOperatorsDo: aBlock [
	operators keysAndValuesDo:
		[ :symbol :byKindArity |
		  byKindArity keysAndValuesDo:
			[ :kindArity :operator |
			  operator withRanksDo:
				[ :args :sort |
				  aBlock value: symbol value: args asArgSorts value: sort ]]]

]

{ #category : #enumerating }
LeibnizSignature >> withVariablesDo: aBlock [
	variables associationsDo: [ :v | aBlock value: v key value: v value ]

]
