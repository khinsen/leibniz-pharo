Class {
	#name : #LzInfixOpName,
	#superclass : #LzOpName,
	#category : #'Leibniz2-Declarations'
}

{ #category : #'instance creation' }
LzInfixOpName class >> for: aStringOrSymbol [
	^ self new internalSymbol: '_', aStringOrSymbol
]

{ #category : #converting }
LzInfixOpName >> addAsRopedTextTo: aRopedText [
	aRopedText append:
		(internalSymbol allButFirst asRopedText attribute: LzInfixOpNameAttribute new).
]

{ #category : #converting }
LzInfixOpName >> addForArgs: anArrayOfTerms asRopedTextTo: aRopedText argAttributes: anArrayOfAttributes [
	self assert: anArrayOfTerms size equals: 2.
	self
		do: [ :t |
			anArrayOfTerms first
				addAsFirstArgOfInfixTermWithOpName: self
				asRopedTextTo: t ]
		to: aRopedText
		withAttributes: anArrayOfAttributes.
	aRopedText append: ' ' asRopedText.
	self addAsRopedTextTo: aRopedText.
	aRopedText append:  ' ' asRopedText.
	self
		do: [ :t |
			anArrayOfTerms second
				addAsRopedTextTo: t
				parenthesized: anArrayOfTerms second isInfix ]
		to: aRopedText
		withAttributes: anArrayOfAttributes
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
	anArity first
		printAsLeibnizSyntaxOn: aStream
		parenthesized: anArity first isInfix.
	aStream nextPut: Character space.
	aStream nextPutAll: internalSymbol allButFirst.
	aStream nextPut: Character space.
	anArity second
		printAsLeibnizSyntaxOn: aStream
		parenthesized: anArity second isInfix.
]

{ #category : #inspecting }
LzInfixOpName >> synopsis [
	^ '• ', internalSymbol allButFirst, ' •'
]
