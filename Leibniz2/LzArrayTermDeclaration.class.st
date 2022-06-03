Class {
	#name : #LzArrayTermDeclaration,
	#superclass : #LzTermDeclaration,
	#instVars : [
		'elements',
		'shape'
	],
	#category : #'Leibniz2-Declarations'
}

{ #category : #constructing }
LzArrayTermDeclaration >> buildFor: aSignature variables: aDictionary [
	^ aSignature
		arrayTerm: (self elements flattened collect: [ :each |
						each buildFor: aSignature variables: aDictionary ])
		shape: self shape
]

{ #category : #asserting }
LzArrayTermDeclaration >> checkDimensions: anArray [
	anArray ifNotEmpty: [
		anArray first isSequenceable
			ifTrue: [ self assert:
				(anArray allSatisfy: [ :each |
					each isSequenceable
						and: [ each size = anArray first size ] ]).
				anArray do: [ :each | self checkDimensions: each ] ]
			ifFalse: [ self assert:
				(anArray allSatisfy: [ :each |
					each isSequenceable not ]) ] ] 
]

{ #category : #constructing }
LzArrayTermDeclaration >> elements [
	^ elements
]

{ #category : #initialization }
LzArrayTermDeclaration >> elements: anArray [
	elements := anArray.
	shape := self shapeFor: anArray
]

{ #category : #printing }
LzArrayTermDeclaration >> printAsLeibnizSyntaxOn: aStream [
	aStream << ${.
	self printElementsOf: elements asLeibnizSyntaxOn: aStream.
	aStream << $}
]

{ #category : #printing }
LzArrayTermDeclaration >> printElementsOf: anArray asLeibnizSyntaxOn: aStream [
	aStream << $[.
	1 to: anArray size do: [ :eachIndex |
		| element |
		element := anArray at: eachIndex.
		element isCollection
			ifTrue: [ self printElementsOf: element asLeibnizSyntaxOn: aStream ]
			ifFalse: [ element printAsLeibnizSyntaxOn: aStream ].
		eachIndex < anArray size ifTrue: [ aStream << ', ' ] ].
	aStream << $]
]

{ #category : #constructing }
LzArrayTermDeclaration >> shape [
	^ shape
]

{ #category : #initialization }
LzArrayTermDeclaration >> shapeFor: anArray [
	| subshapes |
	anArray ifEmpty: [ ^ #(0) ].
	anArray first isCollection ifFalse: [
		self assert: (anArray allSatisfy: [ :each |
							each isCollection not ]).
		^ { anArray size } ].
	self assert: (anArray allSatisfy: [ :each |
						each isCollection ]).
	subshapes := anArray collect: [ :each | self shapeFor: each ].
	self assert: subshapes asSet size equals: 1.
	^ { anArray size }, subshapes first
]
