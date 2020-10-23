"
!A term parser subclass that parses rules without variables

This subclass of ${class:name=LbTermParser}$ adds a few straightforward productions for parsing Leibniz rules that contain no variables, i.e. no for-all clauses. The full rule parser is ${class:name=LeibnizRuleParser}$.

"
Class {
	#name : #LeibnizNoVarRuleParser,
	#superclass : #LbTermParser,
	#instVars : [
		'code',
		'noVarRewriteRule',
		'noVarFnRule',
		'noVarRule',
		'conditionClause',
		'rewriteArrow',
		'fnArrow',
		'underCondition'
	],
	#category : #'Leibniz-4-Rules'
}

{ #category : #productions }
LeibnizNoVarRuleParser >> code [
	^ $' asPParser , $' asPParser negate star flatten, $' asPParser, $: asPParser, identifier
		==> [ :nodes | { nodes second. nodes fifth } ]

]

{ #category : #productions }
LeibnizNoVarRuleParser >> conditionClause [
	^ underCondition trim, term
		==> [ :nodes | nodes at: 2 ]

]

{ #category : #tokens }
LeibnizNoVarRuleParser >> fnArrow [
	^ $→ asPParser
]

{ #category : #productions }
LeibnizNoVarRuleParser >> noVarFnRule [
	^ term, fnArrow trim, code, conditionClause optional
		==> [ :nodes |
				LeibnizFunctionRule pattern: nodes first
										  localVariables: extraVariables
									 	  condition: nodes fourth 
										  function: nodes third ]
]

{ #category : #productions }
LeibnizNoVarRuleParser >> noVarRewriteRule [
	^ term, rewriteArrow trim, term, conditionClause optional
		==> [ :nodes |
				LeibnizRewriteRule pattern: nodes first
								localVariables: extraVariables
							   condition: nodes fourth 
								replacement: nodes third ]
]

{ #category : #productions }
LeibnizNoVarRuleParser >> noVarRule [
	^ noVarRewriteRule / noVarFnRule
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
