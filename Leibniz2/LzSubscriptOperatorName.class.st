Class {
	#name : #LzSubscriptOperatorName,
	#superclass : #LzOperatorName,
	#category : #'Leibniz2-Parser'
}

{ #category : #initializing }
LzSubscriptOperatorName >> initialize [
	internalSymbol := #'_'
]

{ #category : #printing }
LzSubscriptOperatorName >> printForArgs: anArrayOfTerms on: aStream [
	self assert: anArrayOfTerms size > 1.
	anArrayOfTerms first
		printAsLeibnizSyntaxOn: aStream
		parenthesized: anArrayOfTerms first isInfix.
	aStream nextPutAll: '_{'.
	anArrayOfTerms allButFirst allButLast do: [ : each |
		each printAsLeibnizSyntaxOn: aStream.
		aStream nextPutAll: ', ' ].
	anArrayOfTerms last printAsLeibnizSyntaxOn: aStream.
	aStream nextPut: $}
]

{ #category : #printing }
LzSubscriptOperatorName >> printForArity: anArity on: aStream [
	self assert: anArity size > 1.
	anArity first printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: '_{'.
	anArity allButFirst allButLast do: [ : each |
		each printAsLeibnizSyntaxOn: aStream.
		aStream nextPutAll: ', ' ].
	anArity last printAsLeibnizSyntaxOn: aStream.
	aStream nextPut: $}
]

{ #category : #inspecting }
LzSubscriptOperatorName >> synopsis [
	^ '•_{•}'
]
