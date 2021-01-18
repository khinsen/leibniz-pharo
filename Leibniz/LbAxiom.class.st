Class {
	#name : #LbAxiom,
	#superclass : #Object,
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'variables',
		'signature'
	],
	#category : #'Leibniz-5-Axioms'
}

{ #category : #converting }
LbAxiom >> asLeibnizSyntaxString [
	^ String streamContents: [ :s | self printAsLeibnizSyntaxOn: s ]
]

{ #category : #copying }
LbAxiom >> copy [
	^ self
]

{ #category : #copying }
LbAxiom >> deepCopy [
	^ self
]

{ #category : #printing }
LbAxiom >> printAsLeibnizSyntaxOn: aStream [
	self subclassResponsibility
]

{ #category : #printing }
LbAxiom >> printVariablesAsLeibnizSyntaxOn: aStream [
	variables keysAndValuesDo:
		[ :var :sort |
			aStream nextPutAll: '∀ '.
			aStream nextPutAll: var asSymbol.
			aStream nextPut: $:.
			aStream nextPutAll: sort name.
			aStream nextPutAll: ' ']
]
