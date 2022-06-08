Class {
	#name : #LbGrammarRulesAndAxioms,
	#superclass : #LbGrammarSignaturesAndTerms,
	#instVars : [
		'conditionClause',
		'code',
		'equalityAxiom',
		'subsortAxiom',
		'rewriteRule',
		'fnRule'
	],
	#category : 'Leibniz-0-Infrastructure'
}

{ #category : #axioms }
LbGrammarRulesAndAxioms >> axiom [
	^ (equalityAxiom / subsortAxiom) end
]

{ #category : #rules }
LbGrammarRulesAndAxioms >> code [
	^ $' asPParser , $' asPParser negate star flatten, $' asPParser, $: asPParser, identifier
]

{ #category : #clauses }
LbGrammarRulesAndAxioms >> conditionClause [
	^ conditionSymbol trim, term
]

{ #category : #axioms }
LbGrammarRulesAndAxioms >> equalityAxiom [
	^ forAllClause star trim, term, equalSign trim, term, conditionClause optional
]

{ #category : #accessing }
LbGrammarRulesAndAxioms >> fnRule [
	^ forAllClause star trim, term, fnArrow trim, code, conditionClause optional
]

{ #category : #rules }
LbGrammarRulesAndAxioms >> rewriteRule [
	^ forAllClause star trim, term, rewriteArrow trim, term, conditionClause optional
]

{ #category : #rules }
LbGrammarRulesAndAxioms >> rule [
	^ (rewriteRule / fnRule) end
]

{ #category : #axioms }
LbGrammarRulesAndAxioms >> subsortAxiom [
	^ forAllClause star trim, term, subsortSymbol trim, term
]
