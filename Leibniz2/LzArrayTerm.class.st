Class {
	#name : #LzArrayTerm,
	#superclass : #LzTerm,
	#instVars : [
		'elements',
		'shape',
		'sort'
	],
	#category : #'Leibniz2-Terms'
}

{ #category : #'instance creation' }
LzArrayTerm class >> signature: aSignature value: anArray [
]

{ #category : #accessing }
LzArrayTerm >> args [
	^ elements
]

{ #category : #accessing }
LzArrayTerm >> elements [
	^ elements
]

{ #category : #accessing }
LzArrayTerm >> elements: anArray [
	elements := anArray
]

{ #category : #organizing }
LzArrayTerm >> fingerprint [
	^ #array
]

{ #category : #printing }
LzArrayTerm >> printAsLeibnizSyntaxOn: aStream [
	aStream nextPut: ${.
	self printElements: self elements shape: self shape on: aStream.
	aStream nextPut: $}
]

{ #category : #printing }
LzArrayTerm >> printElements: anArray shape: shapeArray on: aStream [
	| elementShape elementSize index |
	elementShape := shapeArray allButFirst.
	elementSize := elementShape inject: 1 into: [ :product :each | product * each ].
	index := 1.
	aStream << $[.
	1 to: shapeArray first do: [ :each |
		elementShape
			ifEmpty: [ (anArray at: index) printAsLeibnizSyntaxOn: aStream ]
			ifNotEmpty: [
				self
					printElements: (anArray copyFrom: index to: index + elementSize - 1)
					shape: elementShape on: aStream ].
		index := index + elementSize.
		index > anArray size ifFalse: [ aStream << ', ' ] ].
	aStream << $]
]

{ #category : #accessing }
LzArrayTerm >> shape [
	^ shape
]

{ #category : #accessing }
LzArrayTerm >> shape: anArray [
	shape := anArray
]

{ #category : #accessing }
LzArrayTerm >> shapeAsArrayTerm [
	^ self signature
		arrayTerm: (self shape collect: [ :each |
						LzIntegerTerm signature: self signature value: each])
		shape: { self shape size }
]

{ #category : #accessing }
LzArrayTerm >> sort [
	^ sort
]

{ #category : #accessing }
LzArrayTerm >> sort: aSort [
	sort := aSort
]

{ #category : #accessing }
LzArrayTerm >> valueSlots [
	^ #(elements shape)
]

{ #category : #accessing }
LzArrayTerm >> withTransformedArgs: transformedElements [
	^ signature arrayTerm: transformedElements shape: self shape
]
