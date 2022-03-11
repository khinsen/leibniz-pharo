Class {
	#name : #LzASTRationalLiteral,
	#superclass : #LzASTLiteral,
	#category : #'Leibniz2-Parser'
}

{ #category : #accessing }
LzASTRationalLiteral >> builtin [
	^ #rationalNumbers
]

{ #category : #printing }
LzASTRationalLiteral >> printAsLeibnizSyntaxOn: aStream [
	value printOn: aStream
]

{ #category : #accessing }
LzASTRationalLiteral >> termClass [
	^ LzRationalNumberTerm
]
