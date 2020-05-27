Class {
	#name : #LeibnizFunctionRule,
	#superclass : #LeibnizRule,
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'function'
	],
	#category : #'Leibniz-4-Rules'
}

{ #category : #'instance creation' }
LeibnizFunctionRule class >> pattern: aPattern localVariables: aDictionary condition: aBooleanTerm function: aBlock [
	^ self basicNew
			 initializeWithPattern: aPattern
								localVariables: aDictionary
								condition: aBooleanTerm
								function: aBlock;
			yourself
]

{ #category : #rewriting }
LeibnizFunctionRule >> apply: aSubstitution [
	^ function value: signature value: aSubstitution variables
]

{ #category : #converting }
LeibnizFunctionRule >> convertToSignature: aSignature [
	| convertTerm |
	self flag: #todo.
	convertTerm := [ :term | term convertToSignature: aSignature extraVariables: variables ].
	^ self class
		pattern: (convertTerm value: pattern)
	 	localVariables: variables
		condition: (condition ifNotNil: [ convertTerm value: condition ])
		function: function

]

{ #category : #initializing }
LeibnizFunctionRule >> initializeWithPattern: aPattern localVariables: aDictionary condition: aBooleanTerm function: aBlock [
	self initializeWithPattern: aPattern localVariables: aDictionary condition: aBooleanTerm.
	function := aBlock.
	self beRecursivelyReadOnlyObject.
]

{ #category : #printing }
LeibnizFunctionRule >> printAsLeibnizSyntaxOn: aStream [
	self flag: #todo.
	variables keysAndValuesDo:
		[ :var :sort |
			aStream nextPutAll: '∀ '.
			aStream nextPutAll: var.
			aStream nextPut: $:.
			aStream nextPutAll: sort.
			aStream nextPutAll: ' '].
	pattern printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: ' ⇒ '.
"	replacement printAsLeibnizSyntaxOn: aStream.
	condition ifNotNil:
		[ aStream nextPutAll: ' | '. condition printAsLeibnizSyntaxOn: aStream ]."
]
