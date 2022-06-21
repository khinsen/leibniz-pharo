Class {
	#name : #LzSubscriptOpName,
	#superclass : #LzOpName,
	#category : #'Leibniz2-Declarations'
}

{ #category : #converting }
LzSubscriptOpName >> addForArgs: anArrayOfTerms asRopedTextTo: aRopedText argAttributes: anArrayOfAttributes [
	self assert: anArrayOfTerms size > 1.
	self
		do: [ :t |
			anArrayOfTerms first
				addAsRopedTextTo: t
				parenthesized: anArrayOfTerms first isInfix ]
		to: aRopedText
		withAttributes: anArrayOfAttributes.
	aRopedText append: '\(' asRopedText.
	anArrayOfTerms allButFirst
		do: [ : each |
			self
				do: [ :t | each addAsRopedTextTo: t ]
				to: aRopedText
				withAttributes: anArrayOfAttributes ]
		separatedBy: [ aRopedText append: ', ' asRopedText ].
	aRopedText append: ')' asRopedText
]

{ #category : #initializing }
LzSubscriptOpName >> initialize [
	internalSymbol := #'_'
]

{ #category : #printing }
LzSubscriptOpName >> printForArgs: anArrayOfTerms on: aStream [
	self assert: anArrayOfTerms size > 1.
	anArrayOfTerms first
		printAsLeibnizSyntaxOn: aStream
		parenthesized: anArrayOfTerms first isInfix.
	aStream nextPutAll: '\('.
	anArrayOfTerms allButFirst allButLast do: [ : each |
		each printAsLeibnizSyntaxOn: aStream.
		aStream nextPutAll: ', ' ].
	anArrayOfTerms last printAsLeibnizSyntaxOn: aStream.
	aStream nextPut: $)
]

{ #category : #printing }
LzSubscriptOpName >> printForArgs: anENodeArray on: aStream parents: aNodeSet [
	self assert: anENodeArray size > 1.
	anENodeArray first
		printAsLeibnizSyntaxOn: aStream
		parenthesized: anENodeArray first isInfix
		parents: aNodeSet.
	aStream nextPutAll: '\('.
	anENodeArray allButFirst allButLast do: [ : each |
		each printAsLeibnizSyntaxOn: aStream parents: aNodeSet.
		aStream nextPutAll: ', ' ].
	anENodeArray last
		printAsLeibnizSyntaxOn: aStream
		parents: aNodeSet.
	aStream nextPut: $)
]

{ #category : #printing }
LzSubscriptOpName >> printForArity: anArity on: aStream [
	self assert: anArity size > 1.
	anArity first printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: '\('.
	anArity allButFirst allButLast do: [ : each |
		each printAsLeibnizSyntaxOn: aStream.
		aStream nextPutAll: ', ' ].
	anArity last printAsLeibnizSyntaxOn: aStream.
	aStream nextPut: $)
]

{ #category : #inspecting }
LzSubscriptOpName >> synopsis [
	^ '•\(•)'
]
