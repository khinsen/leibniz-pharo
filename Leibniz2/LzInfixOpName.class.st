Class {
	#name : #LzInfixOpName,
	#superclass : #LzOpName,
	#category : #'Leibniz2-Parser'
}

{ #category : #'instance creation' }
LzInfixOpName class >> for: aStringOrSymbol [
	^ self new internalSymbol: '_', aStringOrSymbol
]

{ #category : #testing }
LzInfixOpName >> isEqualityOp [
	^ internalSymbol = #'_=='
]

{ #category : #accessing }
LzInfixOpName >> isInfix [
	^ true
]

{ #category : #testing }
LzInfixOpName >> isInfixOpOtherThan: anOpName [
	^ anOpName ~= self
]

{ #category : #printing }
LzInfixOpName >> printForArgs: anArrayOfTerms on: aStream [
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
LzInfixOpName >> printForArgs: anENodeArray on: aStream parents: aNodeSet [
	self assert: anENodeArray size equals: 2.
	anENodeArray first
		printAsFirstArgOfInfixTermWithOpName: self
		on: aStream
		parents: aNodeSet.
	aStream nextPut: Character space.
	aStream nextPutAll: internalSymbol allButFirst.
	aStream nextPut: Character space.
	anENodeArray second
		printAsLeibnizSyntaxOn: aStream
		parenthesized: anENodeArray second isInfix
		parents: aNodeSet
]

{ #category : #printing }
LzInfixOpName >> printForArity: anArity on: aStream [
	self assert: anArity size equals: 2.
	anArity first printAsLeibnizSyntaxOn: aStream parenthesized: true.
	aStream nextPut: Character space.
	aStream nextPutAll: internalSymbol allButFirst.
	aStream nextPut: Character space.
	anArity second printAsLeibnizSyntaxOn: aStream parenthesized: true.
]

{ #category : #inspecting }
LzInfixOpName >> synopsis [
	^ '• ', internalSymbol allButFirst, ' •'
]
