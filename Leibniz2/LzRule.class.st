Class {
	#name : #LzRule,
	#superclass : #Object,
	#traits : 'TLzEquality + TLzPrintable',
	#classTraits : 'TLzEquality classTrait + TLzPrintable classTrait',
	#instVars : [
		'signature',
		'condition',
		'pattern',
		'variables'
	],
	#category : #'Leibniz2-Rules'
}

{ #category : #rewriting }
LzRule >> apply: bindings [
	self subclassResponsibility
]

{ #category : #'instance creation' }
LzRule >> checkConsistency [
	self assert: pattern signature == signature.
	condition ifNotNil: [
		self assert: condition signature == signature.
		self assert: condition sort asLeibnizSyntaxString equals: 'boolean' ].
	self flag: #todo. "Check variable consistency pattern->condition and pattern->replacement"
]

{ #category : #accessing }
LzRule >> condition [
	^ condition
]

{ #category : #accessing }
LzRule >> condition: aTerm [
	condition := aTerm
]

{ #category : #accessing }
LzRule >> pattern [
	^ pattern
]

{ #category : #accessing }
LzRule >> pattern: aTerm [
	pattern := aTerm
]

{ #category : #printing }
LzRule >> printAsLeibnizSyntaxOn: aStream [
	self printVariablesAsLeibnizSyntaxOn: aStream.
	pattern printAsLeibnizSyntaxOn: aStream.
	aStream nextPutAll: ' ⇒ '.
	self printRHSAsLeibnizSyntaxOn: aStream.
	self condition ifNotNil: [ :c |
		aStream nextPutAll: ' | '.
		self printConditionAsLeibnizSyntaxOn: aStream ].
]

{ #category : #printing }
LzRule >> printConditionAsLeibnizSyntaxOn: aStream [
	self condition ifNotNil: [ :c |
		c printAsLeibnizSyntaxOn: aStream ]
]

{ #category : #printing }
LzRule >> printRHSAsLeibnizSyntaxOn: aStream [
	self subclassResponsibility
]

{ #category : #printing }
LzRule >> printVariablesAsLeibnizSyntaxOn: aStream [
	variables keysAndValuesDo:
		[ :var :sort |
			aStream nextPutAll: '∀ '.
			aStream nextPutAll: var asSymbol.
			aStream nextPut: $:.
			sort printAsLeibnizSyntaxOn:  aStream.
			aStream nextPut: Character space]
]

{ #category : #accessing }
LzRule >> referenceSlots [
	^ #(signature)
]

{ #category : #accessing }
LzRule >> signature [
	^ signature
]

{ #category : #accessing }
LzRule >> signature: aSignature [
	signature := aSignature
]

{ #category : #accessing }
LzRule >> valueSlots [
	^ #(variables pattern condition)
]

{ #category : #accessing }
LzRule >> variables [
	^ variables
]

{ #category : #accessing }
LzRule >> variables: aDictionary [
	variables := aDictionary
]
