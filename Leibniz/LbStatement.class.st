Class {
	#name : #LbStatement,
	#superclass : #Object,
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'variables',
		'signature'
	],
	#category : #'Leibniz-5-Statements'
}

{ #category : #converting }
LbStatement >> asLeibnizSyntaxString [
	^ String streamContents: [ :s | self printAsLeibnizSyntaxOn: s ]
]

{ #category : #copying }
LbStatement >> copy [
	^ self
]

{ #category : #copying }
LbStatement >> deepCopy [
	^ self
]

{ #category : #printing }
LbStatement >> printAsLeibnizSyntaxOn: aStream [
	self subclassResponsibility
]

{ #category : #printing }
LbStatement >> printVariablesAsLeibnizSyntaxOn: aStream [
	variables keysAndValuesDo:
		[ :var :sort |
			aStream nextPutAll: '∀ '.
			aStream nextPutAll: var asSymbol.
			aStream nextPut: $:.
			aStream nextPutAll: sort name.
			aStream nextPutAll: ' ']
]
