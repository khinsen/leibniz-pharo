"
!A term parser subclass that parses rules

Rules are parsed in two steps. The first step is parsing the for-all clauses. The variables declared in these clauses are passed to the second step (implemented in ${class:name=LeibnizNoVarRuleParser}$), together with the signatures. These two items together define which terms are valid inside the rule. 
"
Class {
	#name : #LeibnizRuleParser,
	#superclass : #LeibnizTermParser,
	#instVars : [
		'rule',
		'forAllClause',
		'forAll',
		'colon'
	],
	#category : #'Leibniz-4-Rules'
}

{ #category : #tokens }
LeibnizRuleParser >> colon [
	^ $: asPParser
]

{ #category : #tokens }
LeibnizRuleParser >> forAll [
	^ $∀ asPParser
]

{ #category : #productions }
LeibnizRuleParser >> forAllClause [
	^ forAll trim, identifier, colon, identifier
		==> [ :nodes | (nodes at: 2) asSymbol -> (nodes at: 4) asSymbol ]

]

{ #category : #productions }
LeibnizRuleParser >> rule [
	^ forAllClause star, #any asPParser plus flatten trim
		==> [ :nodes |
				| localVariables |
				localVariables := (nodes at: 1) asDictionary.
				(LeibnizNoVarRuleParser forSignature: signature extraVariables: localVariables)
					parse: (nodes at: 2) ]

]

{ #category : #accessing }
LeibnizRuleParser >> start [
	^ rule end.
]
