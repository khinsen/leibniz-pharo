Class {
	#name : #LbAxiomBuilder,
	#superclass : #Object,
	#instVars : [
		'signature',
		'axioms'
	],
	#category : 'Leibniz-5-Axioms'
}

{ #category : #'instance creation' }
LbAxiomBuilder class >> signature: aSignature [
	^ self basicNew
		initializeWithSignature: aSignature;
		yourself
]

{ #category : #adding }
LbAxiomBuilder >> add: anAxiom [
	(axioms at: anAxiom class name)
		add: anAxiom
]

{ #category : #accessing }
LbAxiomBuilder >> addAxioms: anLbAxioms origin: aContext [
	anLbAxioms declarations do: [ :eachList |
		eachList do: [ :eachDecl |
			self parseAndAdd: eachDecl ] ]
]

{ #category : #accessing }
LbAxiomBuilder >> axioms [
	^ LbAxioms
		signature: signature
		axioms: axioms deepCopy
]

{ #category : #initialization }
LbAxiomBuilder >> initializeWithSignature: aSignature [
	signature := aSignature.
	axioms := Dictionary new.
	LbAxiom subclasses do: [ :each |
		axioms at: each name put: Set new ]
]

{ #category : #adding }
LbAxiomBuilder >> parseAndAdd: aString [
	| parsedAxiom axiom |
	parsedAxiom := (LbParser newStartingAt: #axiom)
					parse: aString.
	parsedAxiom isPetit2Failure ifTrue:
		[ self error: parsedAxiom message, ' after "',
				 (aString sliceFrom: 1 to: parsedAxiom position), '"' ].
	axiom := parsedAxiom value: signature.
	self add: axiom.
]
