Class {
	#name : #LeibnizRuleConstructor,
	#superclass : #LeibnizTermConstructor,
	#instVars : [
		'rule',
		'forAllClause',
		'conditionClause',
		'rewriteArrow',
		'forAll',
		'underCondition'
	],
	#category : #'Leibniz-4-Rules'
}

{ #category : #productions }
LeibnizRuleConstructor >> conditionClause [
	^ underCondition trim, term
		==> [ :nodes | nodes at: 2 ]

]

{ #category : #tokens }
LeibnizRuleConstructor >> forAll [
	^ $∀ asPParser
]

{ #category : #productions }
LeibnizRuleConstructor >> forAllClause [
	^ forAll trim, term
		==> [ :nodes | nodes at: 2 ]

]

{ #category : #tokens }
LeibnizRuleConstructor >> rewriteArrow [
	^ $⇒ asPParser
]

{ #category : #productions }
LeibnizRuleConstructor >> rule [
	^ term, rewriteArrow trim, term, forAllClause star, conditionClause optional
		==> [ :nodes |
				LeibnizRule pattern: (nodes at: 1)
							   condition: (nodes at: 5)
								replacement: (nodes at: 3)]
]

{ #category : #initialization }
LeibnizRuleConstructor >> setSignature: anObject [
	signature := anObject
]

{ #category : #accessing }
LeibnizRuleConstructor >> signature [
	^ signature
]

{ #category : #accessing }
LeibnizRuleConstructor >> start [
	^ rule end.
]

{ #category : #tokens }
LeibnizRuleConstructor >> underCondition [
	^ $| asPParser
]
