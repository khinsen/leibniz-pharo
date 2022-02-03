Class {
	#name : #LzMatchingRules,
	#superclass : #Object,
	#instVars : [
		'rules',
		'term',
		'rewriteSystem'
	],
	#category : #'Leibniz2-Rules'
}

{ #category : #building }
LzMatchingRules >> match [
	rules := OrderedCollection new.
	"Each item in rules is of the form
	 { rule. patternMatches. conditionFulflled. rewrittenTermOrNil }"
	(rules at: self term fingerprint ifAbsent: [ #() ]) do: [ :aRule |
		(aRule pattern match: self term)
			ifSuccess: [ :s |
				(rewriteSystem testCondition: aRule condition substituting: s)
					ifFalse: [ rules add: { aRule. true. false. nil } ]
					ifTrue: [ rules add: { aRule. true. true. aRule apply: s } ] ]
			ifFailure: [ rules add: { aRule. false. false. nil } ] ].
]

{ #category : #accessing }
LzMatchingRules >> rewriteSystem [
	^ rewriteSystem
]

{ #category : #accessing }
LzMatchingRules >> rewriteSystem: aRewriteSystem [
	rewriteSystem := aRewriteSystem
]

{ #category : #accessing }
LzMatchingRules >> term [
	^ term
]

{ #category : #accessing }
LzMatchingRules >> term: aTerm [
	term := aTerm
]
