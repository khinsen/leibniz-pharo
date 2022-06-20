Class {
	#name : #LzKind,
	#superclass : #Object,
	#traits : 'TLzEquality + TLzPrintable',
	#classTraits : 'TLzEquality classTrait + TLzPrintable classTrait',
	#instVars : [
		'sortGraph',
		'maximalFamilies',
		'sortFamilies'
	],
	#category : #'Leibniz2-Sorts'
}

{ #category : #converting }
LzKind >> addAsRopedTextTo: aRopedText [
	self
		do: [ :t |
				t append: '[' asRopedText.
				t append: (', ' join: (maximalFamilies collect: #asLeibnizSyntaxString)) asRopedText.
				t append: ']' asRopedText ]
		to: aRopedText
		withAttribute: LzSortAttribute new
]

{ #category : #testing }
LzKind >> includes: aSort [
	^ sortFamilies includes: aSort family
]

{ #category : #testing }
LzKind >> isInfix [
	^ false
]

{ #category : #accessing }
LzKind >> maximalFamilies [
	^ maximalFamilies
]

{ #category : #accessing }
LzKind >> maximalFamilies: aSet [
	maximalFamilies := aSet
]

{ #category : #printing }
LzKind >> printAsLeibnizSyntaxOn: aStream [
	aStream nextPut: $[.
	aStream nextPutAll: (', ' join: (maximalFamilies collect: #asLeibnizSyntaxString)).
	aStream nextPut: $]
]

{ #category : #accessing }
LzKind >> referenceSlots [
	^ #(sortGraph)
]

{ #category : #accessing }
LzKind >> sortFamilies [
	^ sortFamilies
]

{ #category : #accessing }
LzKind >> sortFamilies: aSet [
	sortFamilies := aSet
]

{ #category : #accessing }
LzKind >> sortGraph [
	^ sortGraph
]

{ #category : #accessing }
LzKind >> sortGraph: aSortGraph [
	sortGraph := aSortGraph
]

{ #category : #accessing }
LzKind >> valueSlots [
	^ #(sortFamilies maximalFamilies)
]

{ #category : #accessing }
LzKind >> vars [
	^ Dictionary new
]
