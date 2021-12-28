Class {
	#name : #LzSuperscriptOperatorName,
	#superclass : #LzOperatorName,
	#category : #'Leibniz2-Parser'
}

{ #category : #initializing }
LzSuperscriptOperatorName >> initialize [
	internalSymbol := #'^'
]

{ #category : #printing }
LzSuperscriptOperatorName >> printForArgs: aTermArray on: aStream [
	self assert: aTermArray size > 1.
	aTermArray first
		printAsLeibnizSyntaxOn: aStream
		parenthesized: aTermArray first isInfix.
	aStream nextPutAll: '^{'.
	aTermArray allButFirst allButLast do: [ : each |
		each printAsLeibnizSyntaxOn: aStream.
		aStream nextPutAll: ', ' ].
	aTermArray last printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: '}'
]

{ #category : #printing }
LzSuperscriptOperatorName >> printForArity: anArity on: aStream [
	self assert: anArity size > 1.
	anArity first printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: '^{'.
	anArity allButFirst allButLast do: [ : each |
		each printAsLeibnizSyntaxOn: aStream.
		aStream nextPutAll: ', ' ].
	anArity last printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: '}'
]

{ #category : #printing }
LzSuperscriptOperatorName >> synopsis [
	^ '•^{•}'
]
