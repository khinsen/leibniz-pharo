Class {
	#name : #LbFunctionRule,
	#superclass : #LbRule,
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'function',
		'block'
	],
	#category : #'Leibniz-4-Rules'
}

{ #category : #'instance creation' }
LbFunctionRule class >> pattern: aPattern condition: aBooleanTerm function: aString [
	^ self pattern: aPattern localVariables: Dictionary new condition: aBooleanTerm function: aString
]

{ #category : #'instance creation' }
LbFunctionRule class >> pattern: aPattern function: aString [
	^ self pattern: aPattern condition: nil function: aString

]

{ #category : #'instance creation' }
LbFunctionRule class >> pattern: aPattern localVariables: aDictionary condition: aBooleanTerm function: aBlock [
	^ self basicNew
			 initializeWithPattern: aPattern
								localVariables: aDictionary
								condition: aBooleanTerm
								function: aBlock;
			yourself
]

{ #category : #rewriting }
LbFunctionRule >> apply: aSubstitution [
	^ block value: signature value: aSubstitution variables
]

{ #category : #converting }
LbFunctionRule >> convertToSignature: aSignature [
	| convertTerm |
	convertTerm := [ :term | term convertToSignature: aSignature extraVariables: variables ].
	^ self class
		pattern: (convertTerm value: pattern)
	 	localVariables: variables
		condition: (condition ifNotNil: [ convertTerm value: condition ])
		function: function

]

{ #category : #accessing }
LbFunctionRule >> function [
	^ function
]

{ #category : #initializing }
LbFunctionRule >> initializeWithPattern: aPattern localVariables: aDictionary condition: aBooleanTerm function: anArray [
	| code tempClass |
	self initializeWithPattern: aPattern localVariables: aDictionary condition: aBooleanTerm.
	function := anArray.
	code := String streamContents:
		[ :s |
			s nextPutAll: 'block ^ [ :signature :args | | '.
			aDictionary keysDo: [ :each | s nextPutAll: each asSymbol. s nextPut: Character space ].
			s nextPutAll: '| '.
			aDictionary keysDo: [ :each |
										s nextPutAll: each asSymbol.
										s nextPutAll: ' := (args at: '.
										each asSymbol printOn: s.
										s nextPutAll: ') leibnizAtomicTermValue. ' ].
			s nextPutAll: function second.
			s nextPutAll: ' value: ('.
			s nextPutAll: function first.
			s nextPutAll: ') signature: signature ] '].
	tempClass := Object newAnonymousSubclass.
	tempClass compile: code.
	block := tempClass new block.
	self beRecursivelyReadOnlyObject
]

{ #category : #comparing }
LbFunctionRule >> instVarsExcludedFromEquality [
	^#(#block #function)

]

{ #category : #printing }
LbFunctionRule >> printAsLeibnizSyntaxOn: aStream [
	variables keysAndValuesDo:
		[ :var :sort |
			aStream nextPutAll: '∀ '.
			aStream nextPutAll: var asSymbol.
			aStream nextPut: $:.
			aStream nextPutAll: sort name.
			aStream nextPutAll: ' '].
	pattern printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: ' → '''.
	aStream nextPutAll: function first.
	aStream nextPutAll: ''':'.
	aStream nextPutAll: function second.
	condition ifNotNil:
		[ aStream nextPutAll: ' | '. condition printAsLeibnizSyntaxOn: aStream ].
]
