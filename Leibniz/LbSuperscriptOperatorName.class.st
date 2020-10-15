Class {
	#name : #LbSuperscriptOperatorName,
	#superclass : #LbOperatorName,
	#category : #'Leibniz-2-Signatures'
}

{ #category : #initializing }
LbSuperscriptOperatorName >> initialize [
	internalSymbol := #'^'
]

{ #category : #printing }
LbSuperscriptOperatorName >> printForArity: anArity On: aStream [
	self assert: anArity size equals: 2.
	anArity first printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: '^{'.
	anArity second printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: '}'.
]

{ #category : #printing }
LbSuperscriptOperatorName >> synopsis [
	^ ('•^{•}') asRopedText
]
