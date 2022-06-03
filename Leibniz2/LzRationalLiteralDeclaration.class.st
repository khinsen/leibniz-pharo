Class {
	#name : #LzRationalLiteralDeclaration,
	#superclass : #LzLiteralDeclaration,
	#category : #'Leibniz2-Declarations'
}

{ #category : #accessing }
LzRationalLiteralDeclaration >> builtin [
	^ #rationalNumbers
]

{ #category : #printing }
LzRationalLiteralDeclaration >> printAsLeibnizSyntaxOn: aStream [
	value printOn: aStream
]

{ #category : #accessing }
LzRationalLiteralDeclaration >> termClass [
	^ LzRationalNumberTerm
]
