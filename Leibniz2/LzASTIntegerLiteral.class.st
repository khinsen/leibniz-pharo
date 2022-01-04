Class {
	#name : #LzASTIntegerLiteral,
	#superclass : #LzASTLiteral,
	#category : #'Leibniz2-Parser'
}

{ #category : #printing }
LzASTIntegerLiteral >> printAsLeibnizSyntaxOn: aStream [
	value printOn: aStream
]
