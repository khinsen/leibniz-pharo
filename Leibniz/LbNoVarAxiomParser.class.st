Class {
	#name : 'LbNoVarAxiomParser',
	#superclass : 'LbTermParser',
	#instVars : [
		'subsortSymbol',
		'conditionClause',
		'underCondition',
		'equalSign',
		'noVarSubsort',
		'noVarEquality'
	],
	#category : 'Leibniz-5-Axioms'
}

{ #category : 'productions' }
LbNoVarAxiomParser >> conditionClause [
	^ underCondition trim, term
		==> [ :nodes | nodes at: 2 ]

]

{ #category : 'tokens' }
LbNoVarAxiomParser >> equalSign [
	^ $= asPParser
]

{ #category : 'productions' }
LbNoVarAxiomParser >> noVarEquality [
	^ term, equalSign trim, term, conditionClause optional
		==> [ :nodes |
				LbEqualityAxiom
					left: nodes first
					right: nodes third
					localVariables: extraVariables
					condition: nodes fourth ]
]

{ #category : 'accessing' }
LbNoVarAxiomParser >> noVarSubsort [
	^ term, subsortSymbol trim, term
		==> [ :nodes |
				LbSubsortAxiom
					subsort: nodes first
					supersort: nodes third
					localVariables: extraVariables ]
]

{ #category : 'accessing' }
LbNoVarAxiomParser >> start [
	^ (noVarEquality / noVarSubsort) end.
]

{ #category : 'tokens' }
LbNoVarAxiomParser >> subsortSymbol [
	^ $⊆ asPParser
]

{ #category : 'tokens' }
LbNoVarAxiomParser >> underCondition [
	^ $| asPParser
]
