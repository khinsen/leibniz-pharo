Class {
	#name : #LbMatchingRules,
	#superclass : #Object,
	#instVars : [
		'rewriteSystem',
		'term',
		'rules'
	],
	#category : #'Leibniz-4-Rules'
}

{ #category : #adding }
LbMatchingRules >> addMatchingRule: aRule result: aTerm [
	rules add: { aRule. true. true. aTerm }
]

{ #category : #adding }
LbMatchingRules >> addMatchingRuleFailedCondition: aRule [
	rules add: { aRule. true. false. nil }
]

{ #category : #adding }
LbMatchingRules >> addNonMatchingRule: aRule [
	rules add: { aRule. false. false. nil }
]

{ #category : #inspecting }
LbMatchingRules >> gtMatchesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Matches' translated;
		priority: 1;
		items: [ rules ];
		column: 'Variables' lbCode: [ :each |
			| text |
			text := (String streamContents: [ :s |
				each first printVariablesAsLeibnizSyntaxOn: s ])
				asRopedText.
			each second ifFalse: [ text foreground: Color gray ].
			text ];
		column: 'Transformation' lbCode: [ :each |
			| text |
			text := (String streamContents: [ :s |
				each first printBodyAsLeibnizSyntaxOn: s ])
				asRopedText.
			each second ifFalse: [ text foreground: Color gray ].
			text ];
		column: 'Condition' lbCode: [ :each |
			| text color |
			text := (String streamContents: [ :s |
				each first printConditionAsLeibnizSyntaxOn: s ])
				asRopedText.
			color := Color black.
			each second
				ifFalse: [ color := Color gray ]
				ifTrue: [ each third ifFalse: [ color := Color red ] ].
			text foreground: color.
			text ];
		column: 'Result' lbCode: [ :each |
			each fourth
				ifNil: [ '' ]
				ifNotNil: [ :aTerm |
					| text |
					text := aTerm asLeibnizSyntaxString asRopedText.
					each second ifFalse: [ text foreground: Color gray ].
					text ] ];
		yourself
]

{ #category : #initializing }
LbMatchingRules >> initialize [
	rules := OrderedCollection new
]

{ #category : #accessing }
LbMatchingRules >> rewriteSystem [
	^ rewriteSystem
]

{ #category : #accessing }
LbMatchingRules >> rewriteSystem: aRewriteSystem [
	rewriteSystem := aRewriteSystem
]

{ #category : #accessing }
LbMatchingRules >> term [
	^ term
]

{ #category : #accessing }
LbMatchingRules >> term: aTerm [
	term := aTerm
]
