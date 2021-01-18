Class {
	#name : #LbAxiomParser,
	#superclass : #LbTermParser,
	#instVars : [
		'forAllClause',
		'colon',
		'forAll',
		'axiom'
	],
	#category : #'Leibniz-5-Axioms'
}

{ #category : #productions }
LbAxiomParser >> axiom [
	^ forAllClause star, #any asPParser plus flatten trim
		==> [ :nodes |
				| localVariables |
				localVariables := (nodes at: 1) asDictionary.
				(LbNoVarAxiomParser
					signature: signature
					extraVariables: localVariables)
						parse: (nodes at: 2) ]
]

{ #category : #tokens }
LbAxiomParser >> colon [
	^ $: asPParser
]

{ #category : #tokens }
LbAxiomParser >> forAll [
	^ $∀ asPParser
]

{ #category : #productions }
LbAxiomParser >> forAllClause [
	^ forAll trim, identifier, colon, identifier
		==> [ :nodes | (nodes at: 2) asSymbol asLbOperatorName -> (signature sortNamed: (nodes at: 4) asSymbol) ]
]

{ #category : #accessing }
LbAxiomParser >> start [
	^ axiom end.
]
