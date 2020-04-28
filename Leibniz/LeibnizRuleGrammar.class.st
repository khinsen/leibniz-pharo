Class {
	#name : #LeibnizRuleGrammar,
	#superclass : #LeibnizTermGrammar,
	#instVars : [
		'rule',
		'forAllClause',
		'conditionClause',
		'rewriteArrow',
		'forAll',
		'underCondition',
		'colon'
	],
	#category : #'Leibniz-4-Rules'
}

{ #category : #tokens }
LeibnizRuleGrammar >> colon [
	^ $: asPParser
]

{ #category : #productions }
LeibnizRuleGrammar >> conditionClause [
	^ underCondition trim, term

]

{ #category : #tokens }
LeibnizRuleGrammar >> forAll [
	^ $∀ asPParser
]

{ #category : #productions }
LeibnizRuleGrammar >> forAllClause [
	^ forAll trim, identifier, colon, identifier
		==> [ :nodes | (nodes at: 2) asSymbol -> (nodes at: 4) asSymbol ]

]

{ #category : #tokens }
LeibnizRuleGrammar >> rewriteArrow [
	^ $⇒ asPParser
]

{ #category : #productions }
LeibnizRuleGrammar >> rule [
	^ term, rewriteArrow trim, term, forAllClause star, conditionClause optional
		==> [ :nodes | {(nodes at: 1). (nodes at: 3). (nodes at: 4) asDictionary }]
]

{ #category : #accessing }
LeibnizRuleGrammar >> start [
	^ rule end.
]

{ #category : #tokens }
LeibnizRuleGrammar >> underCondition [
	^ $| asPParser
]
