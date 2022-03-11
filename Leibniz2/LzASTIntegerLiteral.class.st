Class {
	#name : #LzASTIntegerLiteral,
	#superclass : #LzASTLiteral,
	#category : #'Leibniz2-Parser'
}

{ #category : #accessing }
LzASTIntegerLiteral >> builtin [
	^ #integers
]

{ #category : #printing }
LzASTIntegerLiteral >> printAsLeibnizSyntaxOn: aStream [
	value printOn: aStream
]

{ #category : #accessing }
LzASTIntegerLiteral >> termClass [
	^ LzIntegerTerm
]
