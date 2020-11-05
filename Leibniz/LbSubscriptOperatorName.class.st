Class {
	#name : #LbSubscriptOperatorName,
	#superclass : #LbOperatorName,
	#category : #'Leibniz-2-Signatures'
}

{ #category : #initializing }
LbSubscriptOperatorName >> initialize [
	internalSymbol := #'_'
]

{ #category : #printing }
LbSubscriptOperatorName >> printForArity: anArity on: aStream [
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
LbSubscriptOperatorName >> synopsis [
	^ '•_{•}'
]
