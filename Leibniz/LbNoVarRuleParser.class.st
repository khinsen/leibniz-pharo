"
!A term parser subclass that parses rules without variables

This subclass of ${class:name=LbTermParser}$ adds a few straightforward productions for parsing Leibniz rules that contain no variables, i.e. no for-all clauses. The full rule parser is ${class:name=LbRuleParser}$.

"
Class {
	#name : 'LbNoVarRuleParser',
	#superclass : 'LbTermParser',
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
	#category : 'Leibniz-4-Rules'
}

{ #category : 'productions' }
LbNoVarRuleParser >> code [
	^ $' asPParser , $' asPParser negate star flatten, $' asPParser, $: asPParser, identifier
		==> [ :nodes | { nodes second. nodes fifth } ]

]

{ #category : 'productions' }
LbNoVarRuleParser >> conditionClause [
	^ underCondition trim, term
		==> [ :nodes | nodes at: 2 ]

]

{ #category : 'tokens' }
LbNoVarRuleParser >> fnArrow [
	^ $→ asPParser
]

{ #category : 'productions' }
LbNoVarRuleParser >> noVarFnRule [
	^ term, fnArrow trim, code, conditionClause optional
		==> [ :nodes |
				LbFunctionRule pattern: nodes first
										  localVariables: extraVariables
									 	  condition: nodes fourth 
										  function: nodes third ]
]

{ #category : 'productions' }
LbNoVarRuleParser >> noVarRewriteRule [
	^ term, rewriteArrow trim, term, conditionClause optional
		==> [ :nodes |
				LbRewriteRule pattern: nodes first
								localVariables: extraVariables
							   condition: nodes fourth 
								replacement: nodes third ]
]

{ #category : 'productions' }
LbNoVarRuleParser >> noVarRule [
	^ noVarRewriteRule / noVarFnRule
]

{ #category : 'tokens' }
LbNoVarRuleParser >> rewriteArrow [
	^ $⇒ asPParser
]

{ #category : 'accessing' }
LbNoVarRuleParser >> start [
	^ noVarRule end.
]

{ #category : 'tokens' }
LbNoVarRuleParser >> underCondition [
	^ $| asPParser
]
