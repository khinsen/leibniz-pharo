Class {
	#name : #LzStringLiteralDeclaration,
	#superclass : #LzLiteralDeclaration,
	#category : #'Leibniz2-Declarations'
}

{ #category : #accessing }
LzStringLiteralDeclaration >> builtin [
	^ #strings
]

{ #category : #accessing }
LzStringLiteralDeclaration >> printAsLeibnizSyntaxOn: aStream [
	aStream nextPut: $".
	aStream nextPutAll: self value.
	aStream nextPut: $"
]

{ #category : #accessing }
LzStringLiteralDeclaration >> termClass [
	^ LzStringTerm
]
