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
	value numerator printOn: aStream.
	value denominator = 1 ifFalse: [
		aStream nextPut: $/.
		value denominator printOn: aStream ]
]

{ #category : #accessing }
LzRationalLiteralDeclaration >> termClass [
	^ LzRationalNumberTerm
]
