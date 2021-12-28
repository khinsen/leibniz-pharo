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
LzSubscriptOperatorName >> printForArgs: aTermArray on: aStream [
	self assert: aTermArray size > 1.
	aTermArray first
		printAsLeibnizSyntaxOn: aStream
		parenthesized: aTermArray first isInfix.
	aStream nextPutAll: '_{'.
	aTermArray allButFirst allButLast do: [ : each |
		each printAsLeibnizSyntaxOn: aStream.
		aStream nextPutAll: ', ' ].
	aTermArray last printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: '}'
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
	aStream nextPutAll: '}'
]

{ #category : #printing }
LzSubscriptOperatorName >> synopsis [
	^ '•_{•}'
]
