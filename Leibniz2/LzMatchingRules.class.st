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

{ #category : #inspecting }
LzMatchingRules >> gtRulesFor: aView [
	<gtView>
	| ruleView topLevel label |
	topLevel := [ :object |
		object isSymbol or: [ object isKindOf: LzOpName] ].
	label := [ :object |
		object isSymbol ifTrue: [ object ] ifFalse: [ object synopsis ] ].
	ruleView := aView columnedList
		title: 'Rules';
		priority: 1;
		items: [ rules ];
		column: 'Match' text: #second width: 50;
		column: 'Condition'
			text: [ :each |
				each second
					ifTrue: [ each third ]
					ifFalse: [ '' ] ]
			width: 60;
		column: 'Rule'
			text: [ :each |
				each first asLeibnizSyntax ]
			width: 600;
		column: 'Result'
			text: [ :each |
				(each second & each third)
					ifTrue: [ each fourth
								ifNil: [ 'error' asRopedText foreground: Color red  ]
								ifNotNil: [ :t | t asLeibnizSyntax ] ]
					ifFalse: [ '' ] ]
			width: 400;
		send: [ :each |
			LzRuleMatcher new
				rule: each first;
				term: self term ];
		yourself.
	self hasConditionalRule ifTrue: [
		ruleView column: 'Condition' text: [ :each |
			| t |
			t := '' asRopedText.
			each first addConditionAsRopedTextTo: t.
			t ] ].
	^ ruleView
]

{ #category : #testing }
LzMatchingRules >> hasConditionalRule [
	rules
		detect: [ :each | each first condition isNotNil ]
		ifFound: [ ^ true ].
	^ false
]

{ #category : #building }
LzMatchingRules >> match [
	rules := OrderedCollection new.
	"Each item in rules is of the form
	 { rule. patternMatches. conditionFulflled. rewrittenTermOrNil }"
	(rewriteSystem rules at: self term fingerprint ifAbsent: [ #(  ) ]) 
		do: [ :aRule | 
			(aRule pattern match: self term)
				ifSuccess: [ :s | 
					| reducer |
					reducer := [ :t | rewriteSystem reduce: t ].
					(aRule testConditionForSubstitution: s reducer: reducer)
						ifFalse: [ rules add: { aRule. true. false. nil } ]
						ifTrue: [
							| rewritten |
							rewritten := [ aRule apply: s reducer: reducer ]
											on: LzRewriteFailure do: [ nil ].
							rules add: { aRule. true. true. rewritten } ] ]
				ifFailure: [ 
					rules add: { aRule. false. false. nil } ] ]
]

{ #category : #accessing }
LzMatchingRules >> rewriteSystem [
	^ rewriteSystem
]

{ #category : #accessing }
LzMatchingRules >> rewriteSystem: aRewriteSystem [
	rewriteSystem := aRewriteSystem
]

{ #category : #building }
LzMatchingRules >> sort [
	rules sort: [ :a :b |
		a second & (b second not) ]
]

{ #category : #accessing }
LzMatchingRules >> term [
	^ term
]

{ #category : #accessing }
LzMatchingRules >> term: aTerm [
	term := aTerm
]
