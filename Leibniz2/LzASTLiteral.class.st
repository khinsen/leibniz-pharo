Class {
	#name : #LzASTLiteral,
	#superclass : #LzASTTerm,
	#instVars : [
		'value'
	],
	#category : #'Leibniz2-Parser'
}

{ #category : #constructing }
LzASTLiteral >> buildFor: aSignature variables: aDictionary [
	aSignature assertBuiltin:  self builtin.
	^ self termClass
		signature: aSignature
		value: self value
]

{ #category : #accessing }
LzASTLiteral >> builtin [
	self subclassResponsibility
]

{ #category : #printing }
LzASTLiteral >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	value printOn: aStream.
	aStream nextPut: $)
]

{ #category : #accessing }
LzASTLiteral >> termClass [
	self subclassResponsibility
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
