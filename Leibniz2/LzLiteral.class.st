Class {
	#name : #LzLiteral,
	#superclass : #Object,
	#instVars : [
		'value',
		'type'
	],
	#category : #'Leibniz2-Parser'
}

{ #category : #printing }
LzLiteral >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	type printOn: aStream.
	aStream nextPutAll: ': '.
	value printOn: aStream.
	aStream nextPut: $)
]

{ #category : #accessing }
LzLiteral >> type [
	^ type
]

{ #category : #accessing }
LzLiteral >> type: aSymbol [
	type := aSymbol
]

{ #category : #accessing }
LzLiteral >> value [
	^ value
]

{ #category : #accessing }
LzLiteral >> value: anObject [
	value := anObject
]
