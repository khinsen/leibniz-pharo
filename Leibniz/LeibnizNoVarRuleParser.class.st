"
!A term parser subclass that parses rules without variables

This subclass of ${class:name=LeibnizTermParser}$ adds a few straightforward productions for parsing Leibniz rules that contain no variables, i.e. no for-all clauses. The full rule parser is ${class:name=LeibnizRuleParser}$.

"
Class {
	#name : #LeibnizNoVarRuleParser,
	#superclass : #LeibnizTermParser,
	#instVars : [
		'noVarRule',
		'conditionClause',
		'rewriteArrow',
		'underCondition'
	],
	#category : #'Leibniz-4-Rules'
}

{ #category : #productions }
LeibnizNoVarRuleParser >> conditionClause [
	^ underCondition trim, term
		==> [ :nodes | nodes at: 2 ]

]

{ #category : #productions }
LeibnizNoVarRuleParser >> noVarRule [
	^ term, rewriteArrow trim, term, conditionClause optional
		==> [ :nodes |
				LeibnizRule pattern: (nodes at: 1)
								localVariables: extraVariables
							   condition: (nodes at: 4)
								replacement: (nodes at: 3)]
]

{ #category : #tokens }
LeibnizNoVarRuleParser >> rewriteArrow [
	^ $⇒ asPParser
]

{ #category : #accessing }
LeibnizNoVarRuleParser >> start [
	^ noVarRule end.
]

{ #category : #tokens }
LeibnizNoVarRuleParser >> underCondition [
	^ $| asPParser
]
