Class {
	#name : #LzAxiom,
	#superclass : #Object,
	#traits : 'TLzEquality + TLzPrintable',
	#classTraits : 'TLzEquality classTrait + TLzPrintable classTrait',
	#instVars : [
		'signature',
		'variables'
	],
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #'instance creation' }
LzAxiom class >> signature: aSignature declaration: anASTAxiomNode [
	| variables axiom |
	variables := (anASTAxiomNode variables collect: [ :each |
		each name -> (aSignature sortGraph parsedSort: each sort) ])
			asDictionary.
	axiom := (self subclassFor: anASTAxiomNode) new
		signature: aSignature;
		variables: variables.
	(anASTAxiomNode valueSlots copyWithout:  #variables) do: [ :each |
		| termNode term |
		termNode := anASTAxiomNode instVarNamed: each.
		term := (aSignature parsedTerm: termNode variables: variables).
		axiom perform: (each, ':') with: term ].
	^ axiom
]

{ #category : #'instance creation' }
LzAxiom class >> subclassFor: anASTAxiomNode [
	(anASTAxiomNode isKindOf: LzASTSubsortAxiom)
		ifTrue: [ ^ LzSubsortAxiom ]
]

{ #category : #printing }
LzAxiom >> printVariablesAsLeibnizSyntaxOn: aStream [
	variables keysAndValuesDo:
		[ :var :sort |
			aStream nextPutAll: '∀ '.
			aStream nextPutAll: var asSymbol.
			aStream nextPut: $:.
			aStream nextPutAll: sort name.
			aStream nextPutAll: ' ']
]

{ #category : #accessing }
LzAxiom >> referenceSlots [
	^ #(signature)
]

{ #category : #accessing }
LzAxiom >> signature [
	^ signature
]

{ #category : #accessing }
LzAxiom >> signature: aSignature [
	signature := aSignature
]

{ #category : #accessing }
LzAxiom >> variables [
	^ variables
]

{ #category : #accessing }
LzAxiom >> variables: aDictionary [
	variables := aDictionary
]
