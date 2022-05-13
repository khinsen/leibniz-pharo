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
		column: 'Match' text: #second;
		column: 'Condition' text: [ :each |
			each second
				ifTrue: [ each third ]
				ifFalse: [ '' ] ];
		column: 'Variables' lzCode: [ :each |
			String streamContents: [ :s |
				each first printVariablesAsLeibnizSyntaxOn: s ] ];
		column: 'Transformation' lzCode: [ :each |
			String streamContents: [ :s |
				each first printBodyAsLeibnizSyntaxOn: s ] ];
		column: 'Result' lzCode: [ :each |
			(each second & each third)
				ifTrue: [ each fourth asLeibnizSyntaxString ]
				ifFalse: [ '' ] ];
		yourself.
	self hasConditionalRule ifTrue: [
		ruleView column: 'Condition' lzCode: [ :each |
			String streamContents: [ :s |
				each first printConditionAsLeibnizSyntaxOn: s ] ] ].
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
							rules add: { aRule. true. true.
											(aRule apply: s reducer: reducer) } ] ]
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

{ #category : #accessing }
LzMatchingRules >> term [
	^ term
]

{ #category : #accessing }
LzMatchingRules >> term: aTerm [
	term := aTerm
]
