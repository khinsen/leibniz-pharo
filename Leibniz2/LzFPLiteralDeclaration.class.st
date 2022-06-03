Class {
	#name : #LzFPLiteralDeclaration,
	#superclass : #LzLiteralDeclaration,
	#category : #'Leibniz2-Declarations'
}

{ #category : #accessing }
LzFPLiteralDeclaration >> builtin [
	^ #floatingPointNumbers
]

{ #category : #accessing }
LzFPLiteralDeclaration >> printAsLeibnizSyntaxOn: aStream [
	value printOn: aStream
]

{ #category : #accessing }
LzFPLiteralDeclaration >> termClass [
	^ LzFloatingPointNumberTerm
]
