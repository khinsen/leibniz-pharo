Class {
	#name : #LbStatementParser,
	#superclass : #LbTermParser,
	#instVars : [
		'forAllClause',
		'colon',
		'forAll',
		'statement'
	],
	#category : #'Leibniz-5-Statements'
}

{ #category : #tokens }
LbStatementParser >> colon [
	^ $: asPParser
]

{ #category : #tokens }
LbStatementParser >> forAll [
	^ $∀ asPParser
]

{ #category : #productions }
LbStatementParser >> forAllClause [
	^ forAll trim, identifier, colon, identifier
		==> [ :nodes | (nodes at: 2) asSymbol asLbOperatorName -> (signature sortNamed: (nodes at: 4) asSymbol) ]
]

{ #category : #accessing }
LbStatementParser >> start [
	^ statement end.
]

{ #category : #productions }
LbStatementParser >> statement [
	^ forAllClause star, #any asPParser plus flatten trim
		==> [ :nodes |
				| localVariables |
				localVariables := (nodes at: 1) asDictionary.
				(LbNoVarStatementParser
					signature: signature
					extraVariables: localVariables)
						parse: (nodes at: 2) ]
]
