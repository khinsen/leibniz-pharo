Class {
	#name : #LzSignature,
	#superclass : #Object,
	#instVars : [
		'sortGraph',
		'operators',
		'variables'
	],
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #accessing }
LzSignature >> operators [
	^ operators
]

{ #category : #accessing }
LzSignature >> operators: anObject [
	operators := anObject
]

{ #category : #accessing }
LzSignature >> sortGraph [
	^ sortGraph
]

{ #category : #accessing }
LzSignature >> sortGraph: aSortGraph [
	sortGraph := aSortGraph
]

{ #category : #accessing }
LzSignature >> variables [
	^ variables
]

{ #category : #accessing }
LzSignature >> variables: aDictionary [
	variables := aDictionary
]
