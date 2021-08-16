Class {
	#name : 'LbBracketOperatorName',
	#superclass : 'LbOperatorName',
	#category : 'Leibniz-2-Signatures'
}

{ #category : 'initializing' }
LbBracketOperatorName >> initialize [
	internalSymbol := #'[]'
]

{ #category : 'printing' }
LbBracketOperatorName >> printForArgs: aTermArray on: aStream [
	self assert: aTermArray size > 1.
	aTermArray first
		printAsLeibnizSyntaxOn: aStream
		parenthesized: aTermArray first isInfix.
	aStream nextPutAll: '['.
	aTermArray allButFirst allButLast do: [ : each |
		each printAsLeibnizSyntaxOn: aStream.
		aStream nextPutAll: ', ' ].
	aTermArray last printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: ']'
]

{ #category : 'printing' }
LbBracketOperatorName >> printForArity: anArity on: aStream [
	self assert: anArity size > 1.
	anArity first printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: '['.
	anArity allButFirst allButLast do: [ : each |
		each printAsLeibnizSyntaxOn: aStream.
		aStream nextPutAll: ', ' ].
	anArity last printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: ']'
]

{ #category : 'printing' }
LbBracketOperatorName >> synopsis [
	^ '•[• ...]'
]
