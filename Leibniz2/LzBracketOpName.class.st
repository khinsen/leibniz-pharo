Class {
	#name : #LzBracketOpName,
	#superclass : #LzOpName,
	#category : #'Leibniz2-Declarations'
}

{ #category : #accessing }
LzBracketOpName >> addAsRopedTextTo: aRopedText [
	aRopedText append: internalSymbol asRopedText
]

{ #category : #converting }
LzBracketOpName >> addForArgs: anArrayOfTerms asRopedTextTo: aRopedText argAttributes: anArrayOfAttributes [
	self assert: anArrayOfTerms size > 1.
	self
		do: [ :t |
			anArrayOfTerms first
				addAsRopedTextTo: t
				parenthesized: anArrayOfTerms first isInfix ]
		to: aRopedText
		withAttributes: anArrayOfAttributes.
	aRopedText append: '[' asRopedText.
	anArrayOfTerms allButFirst
		do: [ : each |
			self
				do: [ :t | each addAsRopedTextTo: t ]
				to: aRopedText
				withAttributes: anArrayOfAttributes ]
		separatedBy: [ aRopedText append: ', ' asRopedText ].
	aRopedText append: ']' asRopedText
]

{ #category : #initializing }
LzBracketOpName >> initialize [
	internalSymbol := #'[]'
]

{ #category : #printing }
LzBracketOpName >> printForArgs: anArrayOfTerms on: aStream [
	self assert: anArrayOfTerms size > 1.
	anArrayOfTerms first
		printAsLeibnizSyntaxOn: aStream
		parenthesized: anArrayOfTerms first isInfix.
	aStream nextPut: $[.
	anArrayOfTerms allButFirst allButLast do: [ : each |
		each printAsLeibnizSyntaxOn: aStream.
		aStream nextPutAll: ', ' ].
	anArrayOfTerms last printAsLeibnizSyntaxOn: aStream.
	aStream nextPut: $]
]

{ #category : #printing }
LzBracketOpName >> printForArgs: anENodeArray on: aStream parents: aNodeSet [
	self assert: anENodeArray size > 1.
	anENodeArray first
		printAsLeibnizSyntaxOn: aStream
		parents: aNodeSet.
	aStream nextPut: $[.
	anENodeArray allButFirst allButLast do: [ : each |
		each printAsLeibnizSyntaxOn: aStream parents: aNodeSet.
		aStream nextPutAll: ', ' ].
	anENodeArray last
		printAsLeibnizSyntaxOn: aStream parents: aNodeSet.
	aStream nextPut: $]
]

{ #category : #printing }
LzBracketOpName >> printForArity: anArity on: aStream [
	self assert: anArity size > 1.
	anArity first printAsLeibnizSyntaxOn: aStream.
	aStream nextPut: $[.
	anArity allButFirst allButLast do: [ : each |
		each printAsLeibnizSyntaxOn: aStream.
		aStream nextPutAll: ', ' ].
	anArity last printAsLeibnizSyntaxOn: aStream.
	aStream nextPut: $]
]

{ #category : #inspecting }
LzBracketOpName >> synopsis [
	^ '•[• ...]'
]
