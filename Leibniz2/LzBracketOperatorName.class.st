Class {
	#name : #LzBracketOperatorName,
	#superclass : #LzOperatorName,
	#category : #'Leibniz2-Parser'
}

{ #category : #initializing }
LzBracketOperatorName >> initialize [
	internalSymbol := #'[]'
]

{ #category : #printing }
LzBracketOperatorName >> printForArgs: anArrayOfTerms on: aStream [
	self assert: anArrayOfTerms size > 1.
	anArrayOfTerms first
		printAsLeibnizSyntaxOn: aStream
		parenthesized: anArrayOfTerms first isInfix.
	aStream nextPut: $[.
	anArrayOfTerms allButFirst allButLast do: [ : each |
		each printAsLeibnizSyntaxOn: aStream.
		aStream nextPutAll: ', ' ].
	anArrayOfTerms last printAsLeibnizSyntaxOn: aStream.
	aStream nextPut: $]
]

{ #category : #printing }
LzBracketOperatorName >> printForArity: anArity on: aStream [
	self assert: anArity size > 1.
	anArity first printAsLeibnizSyntaxOn: aStream.
	aStream nextPut: $[.
	anArity allButFirst allButLast do: [ : each |
		each printAsLeibnizSyntaxOn: aStream.
		aStream nextPutAll: ', ' ].
	anArity last printAsLeibnizSyntaxOn: aStream.
	aStream nextPut: $]
]

{ #category : #inspecting }
LzBracketOperatorName >> synopsis [
	^ '•[• ...]'
]
