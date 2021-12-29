Class {
	#name : #LzGrammarRulesAndAxioms,
	#superclass : #LzGrammarSignaturesAndTerms,
	#instVars : [
		'conditionClause',
		'code',
		'equalityAxiom',
		'subsortAxiom',
		'rewriteRule',
		'fnRule'
	],
	#category : #'Leibniz2-Parser'
}

{ #category : #axioms }
LzGrammarRulesAndAxioms >> axiom [
	^ (equalityAxiom / subsortAxiom) end
]

{ #category : #rules }
LzGrammarRulesAndAxioms >> code [
	^ $' asPParser , $' asPParser negate star flatten, $' asPParser, $: asPParser, opIdentifier
]

{ #category : #clauses }
LzGrammarRulesAndAxioms >> conditionClause [
	^ conditionSymbol trim, term
]

{ #category : #axioms }
LzGrammarRulesAndAxioms >> equalityAxiom [
	^ forAllClause star trim, term, equalSign trim, term, conditionClause optional
]

{ #category : #accessing }
LzGrammarRulesAndAxioms >> fnRule [
	^ forAllClause star trim, term, fnArrow trim, code, conditionClause optional
]

{ #category : #rules }
LzGrammarRulesAndAxioms >> rewriteRule [
	^ forAllClause star trim, term, rewriteArrow trim, term, conditionClause optional
]

{ #category : #rules }
LzGrammarRulesAndAxioms >> rule [
	^ (rewriteRule / fnRule) end
]

{ #category : #axioms }
LzGrammarRulesAndAxioms >> subsortAxiom [
	^ forAllClause star trim, term, subsortSymbol trim, term
]

{ #category : #axioms }
LzGrammarRulesAndAxioms >> subsortAxiomEnd [
	^ subsortAxiom end
]
