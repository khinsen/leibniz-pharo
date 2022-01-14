Class {
	#name : #LzASTLiteral,
	#superclass : #LzASTTerm,
	#instVars : [
		'value'
	],
	#category : #'Leibniz2-Parser'
}

{ #category : #printing }
LzASTLiteral >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	value printOn: aStream.
	aStream nextPut: $)
]

{ #category : #accessing }
LzASTLiteral >> value [
	^ value
]

{ #category : #accessing }
LzASTLiteral >> value: anObject [
	value := anObject
]

{ #category : #accessing }
LzASTLiteral >> valueSlots [
	^ #(value)
]
