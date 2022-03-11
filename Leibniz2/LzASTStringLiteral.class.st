Class {
	#name : #LzASTStringLiteral,
	#superclass : #LzASTLiteral,
	#category : #'Leibniz2-Parser'
}

{ #category : #accessing }
LzASTStringLiteral >> builtin [
	^ #strings
]

{ #category : #accessing }
LzASTStringLiteral >> printAsLeibnizSyntaxOn: aStream [
	aStream nextPut: $".
	aStream nextPutAll: self value.
	aStream nextPut: $"
]

{ #category : #accessing }
LzASTStringLiteral >> termClass [
	^ LzStringTerm
]
