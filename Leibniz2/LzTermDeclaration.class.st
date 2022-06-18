Class {
	#name : #LzTermDeclaration,
	#superclass : #LzDeclaration,
	#category : #'Leibniz2-Declarations'
}

{ #category : #converting }
LzTermDeclaration >> addAsFirstArgOfInfixTermWithOpName: anOpName asRopedTextTo: aRopedText [
	self
		addAsRopedTextTo: aRopedText
		parenthesized: (self hasInfixOpOtherThan: anOpName)
]

{ #category : #constructing }
LzTermDeclaration >> buildFor: aSignature variables: aDictionary [
	self subclassResponsibility
]

{ #category : #testing }
LzTermDeclaration >> hasInfixOpOtherThan: aSymbol [
	^ false
]

{ #category : #testing }
LzTermDeclaration >> isInfix [
	^ false
]

{ #category : #printing }
LzTermDeclaration >> printAsFirstArgOfInfixTermWithOpName: anOpName on: aStream [
	self
		printAsLeibnizSyntaxOn: aStream
		parenthesized: (self hasInfixOpOtherThan: anOpName)
]
