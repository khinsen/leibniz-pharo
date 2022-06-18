Class {
	#name : #LzPrefixOpName,
	#superclass : #LzOpName,
	#category : #'Leibniz2-Declarations'
}

{ #category : #'instance creation' }
LzPrefixOpName class >> for: aStringOrSymbol [
	^ self new internalSymbol: aStringOrSymbol
]

{ #category : #printing }
LzPrefixOpName >> addForArgs: anArrayOfTerms asRopedTextTo: aRopedText [
	aRopedText append:
		(internalSymbol asRopedText attribute: LzPrefixOpNameAttribute new).
	anArrayOfTerms ifNotEmpty: [
		aRopedText append: ('(' asRopedText attribute: LzParenthesisAttribute new).
		anArrayOfTerms allButLastDo: [ :each |
			each addAsRopedTextTo: aRopedText.
			aRopedText appendString: ', ' ].
		anArrayOfTerms last addAsRopedTextTo: aRopedText.
		aRopedText append: (')' asRopedText attribute: LzParenthesisAttribute new) ]
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
