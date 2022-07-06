Class {
	#name : #LzTupleOpName,
	#superclass : #LzOpName,
	#category : #'Leibniz2-Declarations'
}

{ #category : #converting }
LzTupleOpName >> addForArgs: anArrayOfTerms asRopedTextTo: aRopedText argAttributes: anArrayOfAttributes [
	self assert: anArrayOfTerms size > 0.
	aRopedText append: '(' asRopedText.
	anArrayOfTerms
		do: [ : each |
			self
				do: [ :t | each addAsRopedTextTo: t ]
				to: aRopedText
				withAttributes: anArrayOfAttributes ]
		separatedBy: [ aRopedText append: ', ' asRopedText ].
	aRopedText append: ')' asRopedText
]

{ #category : #initializing }
LzTupleOpName >> initialize [
	internalSymbol := #'()'
]

{ #category : #printing }
LzTupleOpName >> printForArgs: anArrayOfTerms on: aStream [
	self assert: anArrayOfTerms size > 0.
	aStream nextPut: $(.
	anArrayOfTerms
		do: [ : each | each printAsLeibnizSyntaxOn: aStream ]
		separatedBy: [ aStream nextPutAll: ', '  ].
	aStream nextPut: $)
]

{ #category : #printing }
LzTupleOpName >> printForArgs: anENodeArray on: aStream parents: aNodeSet [
	self assert: anENodeArray size > 0.
	aStream nextPut: $(.
	anENodeArray
		do: [ : each | each printAsLeibnizSyntaxOn: aStream parents: aNodeSet ]
		separatedBy: [ aStream nextPutAll: ', ' ].
	aStream nextPut: $)
]

{ #category : #printing }
LzTupleOpName >> printForArity: anArity on: aStream [
	self printForArgs: anArity on: aStream
]

{ #category : #inspecting }
LzTupleOpName >> synopsis [
	^ '(•, ...)'
]
