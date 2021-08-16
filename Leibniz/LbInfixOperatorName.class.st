Class {
	#name : 'LbInfixOperatorName',
	#superclass : 'LbOperatorName',
	#category : 'Leibniz-2-Signatures'
}

{ #category : 'instance creation' }
LbInfixOperatorName class >> for: aStringOrSymbol [
	^ self new internalSymbol: '_', aStringOrSymbol
]

{ #category : 'testing' }
LbInfixOperatorName >> isEqualityOp [
	^ internalSymbol = #'_=='
]

{ #category : 'accessing' }
LbInfixOperatorName >> isInfix [
	^ true
]

{ #category : 'accessing' }
LbInfixOperatorName >> isInfixOpOtherThan: anOpName [
	^ anOpName ~= self
]

{ #category : 'printing' }
LbInfixOperatorName >> printForArgs: aTermArray on: aStream [
	self assert: aTermArray size equals: 2.
	aTermArray first printAsFirstArgOfInfixTermWithOpName: self on: aStream.
	aStream nextPutAll: ' '.
	aStream nextPutAll: internalSymbol allButFirst.
	aStream nextPutAll: ' '.
	aTermArray second
		printAsLeibnizSyntaxOn: aStream
		parenthesized: aTermArray second isInfix
]

{ #category : 'printing' }
LbInfixOperatorName >> printForArity: anArity on: aStream [
	self assert: anArity size equals: 2.
	anArity first printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: ' '.
	aStream nextPutAll: internalSymbol allButFirst.
	aStream nextPutAll: ' '.
	anArity second printAsLeibnizSyntaxOn: aStream.
]

{ #category : 'printing' }
LbInfixOperatorName >> synopsis [
	^ '• ', internalSymbol allButFirst, ' •'
]
