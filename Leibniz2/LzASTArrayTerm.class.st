Class {
	#name : #LzASTArrayTerm,
	#superclass : #LzASTTerm,
	#instVars : [
		'elements',
		'shape'
	],
	#category : #'Leibniz2-Parser'
}

{ #category : #constructing }
LzASTArrayTerm >> buildFor: aSignature variables: aDictionary [
	^ aSignature
		arrayTerm: (self elements flatCollect: [ :each |
						each buildFor: aSignature variables: aDictionary ])
		shape: self shape
]

{ #category : #asserting }
LzASTArrayTerm >> checkDimensions: anArray [
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
LzASTArrayTerm >> elements [
	^ elements
]

{ #category : #accessing }
LzASTArrayTerm >> elements: anArray [
	elements := anArray.
	shape := self shape: anArray
]

{ #category : #printing }
LzASTArrayTerm >> printAsLeibnizSyntaxOn: aStream [
	aStream << ${.
	self printElementsOf: elements asLeibnizSyntaxOn: aStream.
	aStream << $}
]

{ #category : #printing }
LzASTArrayTerm >> printElementsOf: anArray asLeibnizSyntaxOn: aStream [
	aStream << $[.
	anArray do: [ :each |
		each isCollection
			ifTrue: [ self printElementsOf: each asLeibnizSyntaxOn: aStream ]
			ifFalse: [ each printAsLeibnizSyntaxOn: aStream ] ].
	aStream << $]
]

{ #category : #constructing }
LzASTArrayTerm >> shape [
	^ shape
]

{ #category : #asserting }
LzASTArrayTerm >> shape: anArray [
	| subshapes |
	anArray ifEmpty: [ ^ #() ].
	anArray first isCollection ifFalse: [
		self assert: (anArray allSatisfy: [ :each |
							each isCollection not ]).
		^ { anArray size } ].
	self assert: (anArray allSatisfy: [ :each |
						each isCollection ]).
	subshapes := anArray collect: [ :each | self shape: each ].
	self assert: subshapes asSet size equals: 1.
	^ { anArray size }, subshapes first
]
