Class {
	#name : #LzPrefixOpName,
	#superclass : #LzOpName,
	#category : #'Leibniz2-Declarations'
}

{ #category : #'instance creation' }
LzPrefixOpName class >> for: aStringOrSymbol [
	^ self new internalSymbol: aStringOrSymbol
]

{ #category : #converting }
LzPrefixOpName >> addAsRopedTextTo: aRopedText [
	aRopedText append:
		(internalSymbol asRopedText attribute: LzPrefixOpNameAttribute new).
]

{ #category : #converting }
LzPrefixOpName >> addForArgs: anArrayOfTerms asRopedTextTo: aRopedText argAttributes: anArrayOfAttributes [
	self addAsRopedTextTo: aRopedText.
	anArrayOfTerms ifNotEmpty: [
		aRopedText append: '(' asRopedText.
		anArrayOfTerms
			do: [ :each |
				self
					do: [ :t | each addAsRopedTextTo: t ]
					to: aRopedText
					withAttributes: anArrayOfAttributes ]
			separatedBy: [ aRopedText append: ', ' asRopedText ].
		aRopedText append: ')' asRopedText ]
]

{ #category : #printing }
LzPrefixOpName >> printForArgs: anENodeArray on: aStream parents: aNodeSet [
	aStream nextPutAll: internalSymbol.
	anENodeArray ifNotEmpty: [
		aStream nextPut: $(.
		anENodeArray allButLastDo: [ :each |
			each printAsLeibnizSyntaxOn: aStream parents: aNodeSet.
			aStream nextPutAll: ', ' ].
		anENodeArray last
			printAsLeibnizSyntaxOn: aStream
			parents: aNodeSet.
		aStream nextPut: $) ]
]

{ #category : #printing }
LzPrefixOpName >> printForArity: anArity on: aStream [
	aStream nextPutAll: internalSymbol.
	anArity ifNotEmpty: [
		aStream nextPut: $(.
		anArity allButLastDo: [ :each |
			each printAsLeibnizSyntaxOn: aStream.
			aStream nextPutAll: ', ' ].
		anArity last printAsLeibnizSyntaxOn: aStream.
		aStream nextPut: $) ]
]
