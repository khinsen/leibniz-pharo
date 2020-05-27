Class {
	#name : #LeibnizRule,
	#superclass : #Object,
	#instVars : [
		'signature',
		'variables',
		'pattern',
		'condition'
	],
	#category : #'Leibniz-4-Rules'
}

{ #category : #converting }
LeibnizRule >> asLeibnizSyntaxString [
	^ String streamContents: [ :s | self printAsLeibnizSyntaxOn: s ]
]

{ #category : #accessing }
LeibnizRule >> condition [
	^ condition
]

{ #category : #copying }
LeibnizRule >> deepCopy [
	^self
]

{ #category : #initializing }
LeibnizRule >> initializeWithPattern: aPattern localVariables: aDictionary condition: aBooleanTerm [
	| patternVariables |
	pattern := aPattern.
	variables := aDictionary.
	condition := aBooleanTerm.
	signature := pattern signature.

	condition ifNotNil:
		[ self assert: condition signature equals: signature ].

	patternVariables := pattern variables.
	condition ifNotNil: [
		condition variables associationsDo:
			[ :each | self assert: (patternVariables includesAssociation: each)
								description: 'Variable ', each key, ' in condition but not in pattern'  ] ].
]

{ #category : #rewriting }
LeibnizRule >> match: aTerm [
	^ pattern match: aTerm.

]

{ #category : #accessing }
LeibnizRule >> pattern [
	^ pattern
]

{ #category : #printing }
LeibnizRule >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	self printAsLeibnizSyntaxOn: aStream.
	aStream nextPut: $).

]

{ #category : #accessing }
LeibnizRule >> signature [
	^ signature
]

{ #category : #accessing }
LeibnizRule >> variables [
	^ variables
]
