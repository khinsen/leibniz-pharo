Class {
	#name : #LzASTFPLiteral,
	#superclass : #LzASTLiteral,
	#category : #'Leibniz2-Parser'
}

{ #category : #accessing }
LzASTFPLiteral >> builtin [
	^ #floatingPointNumbers
]

{ #category : #accessing }
LzASTFPLiteral >> printAsLeibnizSyntaxOn: aStream [
	value printOn: aStream
]

{ #category : #accessing }
LzASTFPLiteral >> termClass [
	^ LzFloatingPointNumberTerm
]
