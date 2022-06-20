Class {
	#name : #LzSuperscriptOpName,
	#superclass : #LzOpName,
	#category : #'Leibniz2-Declarations'
}

{ #category : #printing }
LzSuperscriptOpName >> addForArgs: anArrayOfTerms asRopedTextTo: aRopedText [
	self assert: anArrayOfTerms size > 1.
	anArrayOfTerms first
		addAsRopedTextTo: aRopedText
		parenthesized: anArrayOfTerms first isInfix.
	aRopedText append: '^(' asRopedText.
	anArrayOfTerms allButFirst allButLast do: [ : each |
		each addAsRopedTextTo: aRopedText.
		aRopedText append: ', ' asRopedText ].
	anArrayOfTerms last addAsRopedTextTo: aRopedText.
	aRopedText append: ')' asRopedText
]

{ #category : #initializing }
LzSuperscriptOpName >> initialize [
	internalSymbol := #'^'
]

{ #category : #printing }
LzSuperscriptOpName >> printForArgs: anArrayOfTerms on: aStream [
	self assert: anArrayOfTerms size > 1.
	anArrayOfTerms first
		printAsLeibnizSyntaxOn: aStream
		parenthesized: anArrayOfTerms first isInfix.
	aStream nextPutAll: '^('.
	anArrayOfTerms allButFirst allButLast do: [ : each |
		each printAsLeibnizSyntaxOn: aStream.
		aStream nextPutAll: ', ' ].
	anArrayOfTerms last printAsLeibnizSyntaxOn: aStream.
	aStream nextPut: $)
]

{ #category : #printing }
LzSuperscriptOpName >> printForArgs: anENodeArray on: aStream parents: aNodeSet [
	self assert: anENodeArray size > 1.
	anENodeArray first
		printAsLeibnizSyntaxOn: aStream
		parenthesized: anENodeArray first isInfix
		parents: aNodeSet.
	aStream nextPutAll: '^('.
	anENodeArray allButFirst allButLast do: [ : each |
		each printAsLeibnizSyntaxOn: aStream parents: aNodeSet.
		aStream nextPutAll: ', ' ].
	anENodeArray last
		printAsLeibnizSyntaxOn: aStream
		parents: aNodeSet.
	aStream nextPut: $)
]

{ #category : #printing }
LzSuperscriptOpName >> printForArity: anArity on: aStream [
	self assert: anArity size > 1.
	anArity first printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: '^('.
	anArity allButFirst allButLast do: [ : each |
		each printAsLeibnizSyntaxOn: aStream.
		aStream nextPutAll: ', ' ].
	anArity last printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: ')'
]

{ #category : #printing }
LzSuperscriptOpName >> synopsis [
	^ '•^(•)'
]
