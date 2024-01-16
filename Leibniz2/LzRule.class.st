Class {
	#name : #LzRule,
	#superclass : #LzTermsWithSharedVars,
	#instVars : [
		'condition',
		'pattern',
		'label',
		'order'
	],
	#category : #'Leibniz2-Rules'
}

{ #category : #converting }
LzRule >> addAsRopedTextTo: aRopedText [
	self label ifNotNil: [ :l |
		self addLabelAsRopedTextTo:  aRopedText.
		aRopedText append: ': ' asRopedText ].
	super addAsRopedTextTo: aRopedText
]

{ #category : #converting }
LzRule >> addConditionAsRopedTextTo: aRopedText [
	self condition ifNotNil: [ :c |
		aRopedText append:
			(' | ' asRopedText attribute: LzConditionAttribute new).
		c addAsRopedTextTo: aRopedText ].
]

{ #category : #converting }
LzRule >> addLabelAsRopedTextTo: aRopedText [
	self label ifNotNil: [ :l |
		aRopedText append:
			(l asRopedText attribute: LzAssetLabelAttribute new).
		self order ifNotNil: [ :o |
			aRopedText append: '[' asRopedText.
			aRopedText append:
				(o asRopedText attribute: LzRuleOrderAttribute new).
			aRopedText append: ']' asRopedText ] ]
]

{ #category : #rewriting }
LzRule >> apply: bindings reducer: aBlock [
	self subclassResponsibility
]

{ #category : #initialization }
LzRule >> buildTermsFrom: anASTRuleNode [
	self pattern:
		(anASTRuleNode pattern
			buildFor: self signature
			variables: variables).
	anASTRuleNode condition ifNotNil: [ :c |
		self condition:
			(c
				buildFor: self signature
				variables: variables)].
]

{ #category : #'instance creation' }
LzRule >> checkConsistency [
	| patternVars |
	self assert: pattern signature == signature.
	patternVars := pattern vars.
	condition ifNotNil: [
		self assert: condition signature == signature.
		self assert: ({ '𝔹'. '[𝔹]'} includes: condition sort asLeibnizSyntaxString).
		condition vars associationsDo: [ :each |
			self
				assert: (patternVars includesAssociation: each)
				description: 'Variable ', each key asSymbol, ' in condition but not in pattern'  ] ]
]

{ #category : #accessing }
LzRule >> condition [
	^ condition
]

{ #category : #accessing }
LzRule >> condition: aTerm [
	condition := aTerm
]

{ #category : #copying }
LzRule >> copy [
	^ self
]

{ #category : #copying }
LzRule >> deepCopy [
	^ self
]

{ #category : #accessing }
LzRule >> label [
	^ label
]

{ #category : #accessing }
LzRule >> label: aSymbol [
	label := aSymbol
]

{ #category : #accessing }
LzRule >> order [
	^ order
]

{ #category : #accessing }
LzRule >> order: aNumber [
	order := aNumber
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
	self printBodyAsLeibnizSyntaxOn: aStream.
	self condition ifNotNil: [ :c |
		aStream nextPutAll: ' | '.
		self printConditionAsLeibnizSyntaxOn: aStream ].
]

{ #category : #printing }
LzRule >> printBodyAsLeibnizSyntaxOn: aStream [
	self subclassResponsibility
]

{ #category : #printing }
LzRule >> printConditionAsLeibnizSyntaxOn: aStream [
	self condition ifNotNil: [ :c |
		c printAsLeibnizSyntaxOn: aStream ]
]

{ #category : #accessing }
LzRule >> signature [
	^ signature
]

{ #category : #accessing }
LzRule >> signature: aSignature [
	signature := aSignature
]

{ #category : #comparing }
LzRule >> sortsBefore: otherRule [
	self label ifNil: [ ^ false ].
	otherRule label ifNil: [ ^ false ].
	self label = otherRule label ifFalse: [ ^ false ].
	self order ifNil: [ ^ false ].
	otherRule order ifNil: [ ^ false ].
	^ self order< otherRule order
]

{ #category : #rewriting }
LzRule >> testConditionForSubstitution: bindings reducer: aBlock [
	self condition ifNil: [ ^ true ].
	[ ^ (aBlock value: (self condition substitute: bindings)) asBooleanValue = true ]
	on: LzRewriteFailure do: [ ^ false ]
]

{ #category : #accessing }
LzRule >> valueSlots [
	^ super valueSlots, #(pattern condition)
]
