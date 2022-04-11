Class {
	#name : #LzASTTerm,
	#superclass : #LzASTNode,
	#category : #'Leibniz2-Parser'
}

{ #category : #constructing }
LzASTTerm >> buildFor: aSignature variables: aDictionary [
	self subclassResponsibility
]

{ #category : #accessing }
LzASTTerm >> hasInfixOpOtherThan: aSymbol [
	^ false
]

{ #category : #testing }
LzASTTerm >> isInfix [
	^ false
]

{ #category : #printing }
LzASTTerm >> printAsFirstArgOfInfixTermWithOpName: anOpName on: aStream [
	self
		printAsLeibnizSyntaxOn: aStream
		parenthesized: (self hasInfixOpOtherThan: anOpName)
]
