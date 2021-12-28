Class {
	#name : #LzInfixOperatorName,
	#superclass : #LzOperatorName,
	#category : #'Leibniz2-Parser'
}

{ #category : #'instance creation' }
LzInfixOperatorName class >> for: aStringOrSymbol [
	^ self new internalSymbol: '_', aStringOrSymbol
]

{ #category : #testing }
LzInfixOperatorName >> isEqualityOp [
	^ internalSymbol = #'_=='
]

{ #category : #accessing }
LzInfixOperatorName >> isInfix [
	^ true
]

{ #category : #accessing }
LzInfixOperatorName >> isInfixOpOtherThan: anOpName [
	^ anOpName ~= self
]

{ #category : #printing }
LzInfixOperatorName >> printForArgs: aTermArray on: aStream [
	self assert: aTermArray size equals: 2.
	aTermArray first printAsFirstArgOfInfixTermWithOpName: self on: aStream.
	aStream nextPutAll: ' '.
	aStream nextPutAll: internalSymbol allButFirst.
	aStream nextPutAll: ' '.
	aTermArray second
		printAsLeibnizSyntaxOn: aStream
		parenthesized: aTermArray second isInfix
]

{ #category : #printing }
LzInfixOperatorName >> printForArity: anArity on: aStream [
	self assert: anArity size equals: 2.
	anArity first printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: ' '.
	aStream nextPutAll: internalSymbol allButFirst.
	aStream nextPutAll: ' '.
	anArity second printAsLeibnizSyntaxOn: aStream.
]

{ #category : #printing }
LzInfixOperatorName >> synopsis [
	^ '• ', internalSymbol allButFirst, ' •'
]
