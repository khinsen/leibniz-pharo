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
