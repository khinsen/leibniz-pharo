Class {
	#name : #LbInfixOperatorName,
	#superclass : #LbOperatorName,
	#category : #'Leibniz-2-Signatures'
}

{ #category : #'instance creation' }
LbInfixOperatorName class >> for: aStringOrSymbol [
	^ self new internalSymbol: '_', aStringOrSymbol
]

{ #category : #printing }
LbInfixOperatorName >> printForArity: anArity on: aStream [
	self assert: anArity size equals: 2.
	anArity first printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: ' '.
	aStream nextPutAll: internalSymbol allButFirst.
	aStream nextPutAll: ' '.
	anArity second printAsLeibnizSyntaxOn: aStream.
]

{ #category : #printing }
LbInfixOperatorName >> synopsis [
	^ '• ', internalSymbol allButFirst, ' •'
]
