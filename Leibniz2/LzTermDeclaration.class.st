Class {
	#name : #LzTermDeclaration,
	#superclass : #LzDeclaration,
	#category : #'Leibniz2-Declarations'
}

{ #category : #constructing }
LzTermDeclaration >> buildFor: aSignature variables: aDictionary [
	self subclassResponsibility
]

{ #category : #accessing }
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
