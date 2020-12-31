Class {
	#name : #LbNoVarStatementParser,
	#superclass : #LbTermParser,
	#instVars : [
		'subsortSymbol',
		'noVarEquation',
		'conditionClause',
		'underCondition',
		'equalSign',
		'noVarSubsort'
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

{ #category : #accessing }
LbNoVarStatementParser >> noVarSubsort [
	^ term, subsortSymbol trim, term
		==> [ :nodes |
				LbSubsortStatement
					subsort: nodes first
					supersort: nodes third
					localVariables: extraVariables ]
]

{ #category : #accessing }
LbNoVarStatementParser >> start [
	^ (noVarEquation / noVarSubsort) end.
]

{ #category : #tokens }
LbNoVarStatementParser >> subsortSymbol [
	^ $⊆ asPParser
]

{ #category : #tokens }
LbNoVarStatementParser >> underCondition [
	^ $| asPParser
]
