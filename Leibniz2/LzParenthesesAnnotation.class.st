Class {
	#name : #LzParenthesesAnnotation,
	#superclass : #LzDeclarationAnnotation,
	#category : #'Leibniz2-Declarations'
}

{ #category : #converting }
LzParenthesesAnnotation >> addAsFirstArgOfInfixTermWithOpName: anOpName asRopedTextTo: aRopedText [
	self declaration addAsRopedTextTo: aRopedText parenthesized: true
]

{ #category : #converting }
LzParenthesesAnnotation >> addAsRopedTextTo: aRopedText [
	self declaration addAsRopedTextTo: aRopedText parenthesized: true
]

{ #category : #constructing }
LzParenthesesAnnotation >> buildFor: aSignature variables: aDictionary [
	^ self declaration buildFor: aSignature variables: aDictionary
]

{ #category : #testing }
LzParenthesesAnnotation >> hasInfixOpOtherThan: aSymbol [
	^ false
]

{ #category : #testing }
LzParenthesesAnnotation >> isInfix [
	^ false
]

{ #category : #printing }
LzParenthesesAnnotation >> printAsFirstArgOfInfixTermWithOpName: anOpName on: aStream [
	self declaration printAsLeibnizSyntaxOn: aStream parenthesized: true
]

{ #category : #printing }
LzParenthesesAnnotation >> printAsLeibnizSyntaxOn: aStream [
	self declaration printAsLeibnizSyntaxOn: aStream parenthesized: true
]
