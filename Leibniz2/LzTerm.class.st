Class {
	#name : #LzTerm,
	#superclass : #Object,
	#traits : 'TLzEquality + TLzPrintable',
	#classTraits : 'TLzEquality classTrait + TLzPrintable classTrait',
	#instVars : [
		'signature'
	],
	#category : #Leibniz2
}

{ #category : #printing }
LzTerm >> hasInfixOpOtherThan: aSymbol [
	^ false
]

{ #category : #testing }
LzTerm >> isInfix [
	^ false
]

{ #category : #printing }
LzTerm >> printAsFirstArgOfInfixTermWithOpName: anOpName on: aStream [
	self
		printAsLeibnizSyntaxOn: aStream
		parenthesized: (self hasInfixOpOtherThan: anOpName)
]

{ #category : #printing }
LzTerm >> printAsLeibnizSyntaxOn: aStream [
	self subclassResponsibility
]

{ #category : #printing }
LzTerm >> printAsLeibnizSyntaxOn: aStream parenthesized: aBoolean [
	aBoolean ifTrue: [ aStream nextPut: $( ].
	self printAsLeibnizSyntaxOn: aStream.
	aBoolean ifTrue: [ aStream nextPut: $) ]
]

{ #category : #printing }
LzTerm >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	self printAsLeibnizSyntaxOn: aStream.
	aStream nextPut: $).
]

{ #category : #accessing }
LzTerm >> referenceSlots [
	^ #(signature)
]

{ #category : #accessing }
LzTerm >> signature [
	^ signature
]

{ #category : #accessing }
LzTerm >> signature: aSignature [
	signature := aSignature
]

{ #category : #accessing }
LzTerm >> sort [
	self subclassResponsibility
]
