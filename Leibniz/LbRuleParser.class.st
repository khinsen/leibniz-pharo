"
!A term parser subclass that parses rules

Rules are parsed in two steps. The first step is parsing the for-all clauses. The variables declared in these clauses are passed to the second step (implemented in ${class:name=LbNoVarRuleParser}$), together with the signatures. These two items together define which terms are valid inside the rule. 
"
Class {
	#name : #LbRuleParser,
	#superclass : #LbTermParser,
	#instVars : [
		'rule',
		'forAllClause',
		'forAll',
		'colon'
	],
	#category : #'Leibniz-4-Rules'
}

{ #category : #tokens }
LbRuleParser >> colon [
	^ $: asPParser
]

{ #category : #tokens }
LbRuleParser >> forAll [
	^ $∀ asPParser
]

{ #category : #productions }
LbRuleParser >> forAllClause [
	^ forAll trim, identifier, colon, identifier
		==> [ :nodes | (nodes at: 2) asSymbol asLbOperatorName -> (signature sortNamed: (nodes at: 4) asSymbol) ]
]

{ #category : #productions }
LbRuleParser >> rule [
	^ forAllClause star, #any asPParser plus flatten trim
		==> [ :nodes |
				| localVariables |
				localVariables := (nodes at: 1) asDictionary.
				(LbNoVarRuleParser signature: signature extraVariables: localVariables)
					parse: (nodes at: 2) ]
]

{ #category : #accessing }
LbRuleParser >> start [
	^ rule end.
]
