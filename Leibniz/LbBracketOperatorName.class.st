Class {
	#name : #LbBracketOperatorName,
	#superclass : #LbOperatorName,
	#category : #'Leibniz-2-Signatures'
}

{ #category : #initializing }
LbBracketOperatorName >> initialize [
	internalSymbol := #'[]'
]

{ #category : #printing }
LbBracketOperatorName >> printForArity: anArity On: aStream [
	self assert: anArity size > 1.
	anArity first printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: '['.
	anArity allButFirst allButLast do: [ : each |
		each printAsLeibnizSyntaxOn: aStream.
		aStream nextPutAll: ', ' ].
	anArity last printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: ']'
]

{ #category : #printing }
LbBracketOperatorName >> synopsis [
	^ '•[• ...]' asRopedText
]
