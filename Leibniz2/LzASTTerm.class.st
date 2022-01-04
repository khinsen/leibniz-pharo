Class {
	#name : #LzASTTerm,
	#superclass : #LzASTNode,
	#category : #'Leibniz2-Parser'
}

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

{ #category : #printing }
LzASTTerm >> printAsLeibnizSyntaxOn: aStream parenthesized: aBoolean [
	aBoolean ifTrue: [ aStream nextPut: $( ].
	self printAsLeibnizSyntaxOn: aStream.
	aBoolean ifTrue: [ aStream nextPut: $) ]
]
