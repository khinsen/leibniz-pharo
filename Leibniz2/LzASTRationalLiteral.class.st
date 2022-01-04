Class {
	#name : #LzASTRationalLiteral,
	#superclass : #LzASTLiteral,
	#category : #'Leibniz2-Parser'
}

{ #category : #printing }
LzASTRationalLiteral >> printAsLeibnizSyntaxOn: aStream [
	value printOn: aStream
]
