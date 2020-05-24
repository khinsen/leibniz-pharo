"
I represent a rewrite rule in a Leibniz context.
"
Class {
	#name : #LeibnizRule,
	#superclass : #Object,
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'signature',
		'variables',
		'pattern',
		'condition',
		'replacement'
	],
	#category : #'Leibniz-4-Rules'
}

{ #category : #'instance creation' }
LeibnizRule class >> pattern: aPattern condition: aBooleanTerm replacement: aTerm [
	^ self pattern: aPattern localVariables: Dictionary new condition: aBooleanTerm replacement: aTerm

]

{ #category : #'instance creation' }
LeibnizRule class >> pattern: aPattern localVariables: aDictionary condition: aBooleanTerm replacement: aTerm [
	^ self basicNew
			 initializeWithPattern: aPattern
								localVariables: aDictionary
								condition: aBooleanTerm
								replacement: aTerm;
			 yourself

]

{ #category : #'instance creation' }
LeibnizRule class >> pattern: aPattern localVariables: aDictionary replacement: aTerm [
	^ self pattern: aPattern localVariables: aDictionary condition: nil replacement: aTerm

]

{ #category : #'instance creation' }
LeibnizRule class >> pattern: aPattern replacement: aTerm [
	^ self pattern: aPattern condition: nil replacement: aTerm

]

{ #category : #converting }
LeibnizRule >> asLeibnizSyntaxString [
	^ String streamContents: [ :s | self printAsLeibnizSyntaxOn: s ]
]

{ #category : #accessing }
LeibnizRule >> condition [
	^ condition
]

{ #category : #converting }
LeibnizRule >> convertToSignature: aSignature [
	| convertTerm |
	convertTerm := [ :term | term convertToSignature: aSignature extraVariables: variables ].
	^ self class
		pattern: (convertTerm value: pattern)
	 	localVariables: variables
		condition: (condition ifNotNil: [ convertTerm value: condition ])
		replacement: (convertTerm value: replacement)

]

{ #category : #initializing }
LeibnizRule >> initializeWithPattern: aPattern localVariables: aDictionary condition: aBooleanTerm replacement: aTerm [
	| patternVariables |
	pattern := aPattern.
	variables := aDictionary.
	condition := aBooleanTerm.
	replacement := aTerm.
	signature := pattern signature.

	self assert: replacement signature equals: signature.
	condition ifNotNil:
		[ self assert: condition signature equals: signature ].

	patternVariables := pattern variables.
	replacement variables associationsDo:
		[ :each | self assert: (patternVariables includesAssociation: each)
							description: 'Variable ', each key, ' in replacement but not in pattern'  ].
	condition ifNotNil: [
		condition variables associationsDo:
			[ :each | self assert: (patternVariables includesAssociation: each)
								description: 'Variable ', each key, ' in condition but not in pattern'  ] ].

]

{ #category : #accessing }
LeibnizRule >> pattern [
	^ pattern
]

{ #category : #printing }
LeibnizRule >> printAsLeibnizSyntaxOn: aStream [
	variables keysAndValuesDo:
		[ :var :sort |
			aStream nextPutAll: '∀ '.
			aStream nextPutAll: var.
			aStream nextPut: $:.
			aStream nextPutAll: sort.
			aStream nextPutAll: ' '].
	pattern printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: ' ⇒ '.
	replacement printAsLeibnizSyntaxOn: aStream.
	condition ifNotNil:
		[ aStream nextPutAll: ' | '. condition printAsLeibnizSyntaxOn: aStream ].
]

{ #category : #printing }
LeibnizRule >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	self printAsLeibnizSyntaxOn: aStream.
	aStream nextPut: $).

]

{ #category : #accessing }
LeibnizRule >> replacement [
	^ replacement
]

{ #category : #rewriting }
LeibnizRule >> rewrite: aTerm [
	| substitution |
	substitution := pattern match: aTerm.
	substitution ifNil: [ ^ aTerm ].
	condition ifNotNil: [ self error: 'Condition must be evaluated in a context' ].
	^ replacement substitute: substitution
]

{ #category : #accessing }
LeibnizRule >> signature [
	^ signature
]

{ #category : #accessing }
LeibnizRule >> variables [
	^ variables
]
