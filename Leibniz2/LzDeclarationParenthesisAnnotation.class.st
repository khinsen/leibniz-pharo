Class {
	#name : #LzDeclarationParenthesisAnnotation,
	#superclass : #LzDeclarationAnnotation,
	#category : #'Leibniz2-Declarations'
}

{ #category : #constructing }
LzDeclarationParenthesisAnnotation >> buildFor: aSignature variables: aDictionary [
	^ self declaration buildFor: aSignature variables: aDictionary
]

{ #category : #testing }
LzDeclarationParenthesisAnnotation >> hasInfixOpOtherThan: aSymbol [
	^ false
]

{ #category : #testing }
LzDeclarationParenthesisAnnotation >> isInfix [
	^ false
]

{ #category : #printing }
LzDeclarationParenthesisAnnotation >> printAsFirstArgOfInfixTermWithOpName: anOpName on: aStream [
	self declaration printAsLeibnizSyntaxOn: aStream parenthesized: true
]

{ #category : #printing }
LzDeclarationParenthesisAnnotation >> printAsLeibnizSyntaxOn: aStream [
	self declaration printAsLeibnizSyntaxOn: aStream parenthesized: true
]
