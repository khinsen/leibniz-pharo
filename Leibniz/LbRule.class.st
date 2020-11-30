Class {
	#name : #LbRule,
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
LbRule >> asLeibnizSyntaxString [
	^ String streamContents: [ :s | self printAsLeibnizSyntaxOn: s ]
]

{ #category : #accessing }
LbRule >> condition [
	^ condition
]

{ #category : #copying }
LbRule >> deepCopy [
	^self
]

{ #category : #inspecting }
LbRule >> gtRuleFor: aView [
	<gtView>
	| ruleView |
	ruleView := aView columnedList
		title: 'Rule' translated;
		priority: 0;
		items: [ { self } ];
		column: 'Variables' lbCode: [ :each |
			String streamContents: [ :s |
				each printVariablesAsLeibnizSyntaxOn: s ] ];
		column: 'Transformation' lbCode: [ :each |
			String streamContents: [ :s |
				each printBodyAsLeibnizSyntaxOn: s ] ].
		condition ifNotNil: [
			ruleView column: 'Condition' lbCode: [ :each |
			String streamContents: [ :s |
				each printConditionAsLeibnizSyntaxOn: s ] ] ].
	^ ruleView
]

{ #category : #initializing }
LbRule >> initializeWithPattern: aPattern localVariables: aDictionary condition: aBooleanTerm [
	| patternVariables |
	pattern := aPattern.
	variables := aDictionary.
	condition := aBooleanTerm.
	signature := pattern signature.

	condition ifNotNil:
		[ self assert: condition signature equals: signature ].

	patternVariables := pattern variables.
	condition ifNotNil: [
		condition variables associationsDo: [ :each |
			self
				assert: (patternVariables includesAssociation: each)
				description: 'Variable ', each key asSymbol, ' in condition but not in pattern'  ] ].
]

{ #category : #accessing }
LbRule >> pattern [
	^ pattern
]

{ #category : #printing }
LbRule >> printAsLeibnizSyntaxOn: aStream [
	self printVariablesAsLeibnizSyntaxOn: aStream.
	self printBodyAsLeibnizSyntaxOn: aStream.
	self printConditionAsLeibnizSyntaxOn: aStream
]

{ #category : #printing }
LbRule >> printBodyAsLeibnizSyntaxOn: aStream [
	self subclassResponsibility
]

{ #category : #printing }
LbRule >> printConditionAsLeibnizSyntaxOn: aStream [
	condition ifNotNil:
		[ aStream nextPutAll: ' | '. condition printAsLeibnizSyntaxOn: aStream ].
]

{ #category : #printing }
LbRule >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	self printAsLeibnizSyntaxOn: aStream.
	aStream nextPut: $).
]

{ #category : #printing }
LbRule >> printVariablesAsLeibnizSyntaxOn: aStream [
	variables keysAndValuesDo:
		[ :var :sort |
			aStream nextPutAll: '∀ '.
			aStream nextPutAll: var asSymbol.
			aStream nextPut: $:.
			aStream nextPutAll: sort name.
			aStream nextPutAll: ' ']
]

{ #category : #accessing }
LbRule >> signature [
	^ signature
]

{ #category : #accessing }
LbRule >> variables [
	^ variables
]
