Class {
	#name : #LzIntegerLiteralDeclaration,
	#superclass : #LzLiteralDeclaration,
	#category : #'Leibniz2-Declarations'
}

{ #category : #accessing }
LzIntegerLiteralDeclaration >> builtin [
	^ #integers
]

{ #category : #printing }
LzIntegerLiteralDeclaration >> printAsLeibnizSyntaxOn: aStream [
	value printOn: aStream
]

{ #category : #accessing }
LzIntegerLiteralDeclaration >> termClass [
	^ LzIntegerTerm
]
