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

{ #category : #testing }
LzInfixOperatorName >> isInfixOpOtherThan: anOpName [
	^ anOpName ~= self
]

{ #category : #printing }
LzInfixOperatorName >> printForArgs: anArrayOfTerms on: aStream [
	self assert: anArrayOfTerms size equals: 2.
	anArrayOfTerms first
		printAsFirstArgOfInfixTermWithOpName: self
		on: aStream.
	aStream nextPut: Character space.
	aStream nextPutAll: internalSymbol allButFirst.
	aStream nextPut: Character space.
	anArrayOfTerms second
		printAsLeibnizSyntaxOn: aStream
		parenthesized: anArrayOfTerms second isInfix
]

{ #category : #printing }
LzInfixOperatorName >> printForArity: anArity on: aStream [
	self assert: anArity size equals: 2.
	anArity first printAsLeibnizSyntaxOn: aStream parenthesized: true.
	aStream nextPut: Character space.
	aStream nextPutAll: internalSymbol allButFirst.
	aStream nextPut: Character space.
	anArity second printAsLeibnizSyntaxOn: aStream parenthesized: true.
]

{ #category : #inspecting }
LzInfixOperatorName >> synopsis [
	^ '• ', internalSymbol allButFirst, ' •'
]
