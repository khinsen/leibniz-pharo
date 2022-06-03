Class {
	#name : #LzLiteralDeclaration,
	#superclass : #LzTermDeclaration,
	#instVars : [
		'value'
	],
	#category : #'Leibniz2-Declarations'
}

{ #category : #constructing }
LzLiteralDeclaration >> buildFor: aSignature variables: aDictionary [
	^ aSignature
		literalTerm: self value
		class: self termClass
		builtin: self builtin
]

{ #category : #accessing }
LzLiteralDeclaration >> builtin [
	self subclassResponsibility
]

{ #category : #printing }
LzLiteralDeclaration >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	value printOn: aStream.
	aStream nextPut: $)
]

{ #category : #accessing }
LzLiteralDeclaration >> termClass [
	self subclassResponsibility
]

{ #category : #accessing }
LzLiteralDeclaration >> value [
	^ value
]

{ #category : #accessing }
LzLiteralDeclaration >> value: anObject [
	value := anObject
]

{ #category : #accessing }
LzLiteralDeclaration >> valueSlots [
	^ #(value)
]
