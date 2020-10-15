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
LbSubscriptOperatorName >> printForArity: anArity On: aStream [
	self assert: anArity size equals: 2.
	anArity first printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: '_{'.
	anArity second printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: '}'.
]

{ #category : #printing }
LbSubscriptOperatorName >> synopsis [
	^ ('•_{•}') asRopedText
]
