Class {
	#name : #LzAxiom,
	#superclass : #Object,
	#traits : 'TLzEquality + TLzPrintable',
	#classTraits : 'TLzEquality classTrait + TLzPrintable classTrait',
	#instVars : [
		'signature',
		'variables'
	],
	#category : #'Leibniz2-Axioms'
}

{ #category : #initialization }
LzAxiom >> buildTermsFrom: aDictionary [
	self subclassResponsibility
]

{ #category : #'instance creation' }
LzAxiom >> checkConsistency [
	self subclassResponsibility
]

{ #category : #printing }
LzAxiom >> printVariablesAsLeibnizSyntaxOn: aStream [
	variables keysAndValuesDo:
		[ :var :sort |
			aStream nextPutAll: '∀ '.
			aStream nextPutAll: var asSymbol.
			aStream nextPut: $:.
			sort printAsLeibnizSyntaxOn:  aStream.
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
