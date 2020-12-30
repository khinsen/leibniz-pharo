Class {
	#name : #LbNoVarStatementParser,
	#superclass : #LbTermParser,
	#instVars : [
		'subsortSymbol',
		'noVarEquation',
		'conditionClause',
		'underCondition',
		'equalSign'
	],
	#category : #'Leibniz-5-Statements'
}

{ #category : #productions }
LbNoVarStatementParser >> conditionClause [
	^ underCondition trim, term
		==> [ :nodes | nodes at: 2 ]

]

{ #category : #tokens }
LbNoVarStatementParser >> equalSign [
	^ $= asPParser
]

{ #category : #productions }
LbNoVarStatementParser >> noVarEquation [
	^ term, equalSign trim, term, conditionClause optional
		==> [ :nodes |
				LbEquation
					left: nodes first
					right: nodes third
					localVariables: extraVariables
					condition: nodes fourth ]
]

{ #category : #productions }
LbNoVarStatementParser >> noVarRewriteRule [
	^ term, rewriteArrow trim, term, conditionClause optional
		==> [ :nodes |
				LbRewriteRule pattern: nodes first
								localVariables: extraVariables
							   condition: nodes fourth 
								replacement: nodes third ]
]

{ #category : #accessing }
LbNoVarStatementParser >> start [
	^ noVarEquation end.
]

{ #category : #tokens }
LbNoVarStatementParser >> subsortSymbol [
	^ $⊆ asPParser
]

{ #category : #tokens }
LbNoVarStatementParser >> underCondition [
	^ $| asPParser
]
