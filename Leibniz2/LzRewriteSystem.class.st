Class {
	#name : #LzRewriteSystem,
	#superclass : #Object,
	#instVars : [
		'rules',
		'signature'
	],
	#category : #'Leibniz2-Rules'
}

{ #category : #inspecting }
LzRewriteSystem >> gtRulesFor: aView [
	<gtView>
	| ruleView |
	ruleView := aView columnedTree
		title: 'Rules';
		priority: 1;
		items: [ rules keys sorted ];
		children: [ :each |
			(each isKindOf: LzOperatorName)
				ifTrue: [ rules at: each ]
				ifFalse: [ #() ] ];
		column: 'Variables' lzCode: [ :each |
			(each isKindOf: LzOperatorName)
				ifTrue: [ each synopsis ]
				ifFalse: [ String streamContents: [ :s |
					each printVariablesAsLeibnizSyntaxOn: s ] ] ];
		column: 'Transformation' lzCode: [ :each |
			(each isKindOf: LzOperatorName)
				ifTrue: [ '' ]
				ifFalse: [ String streamContents: [ :s |
					each printBodyAsLeibnizSyntaxOn: s ] ] ];
		yourself.
	self hasRuleWithCondition ifTrue: [
		ruleView column: 'Condition' lzCode: [ :each |
			(each isKindOf: LzOperatorName)
				ifTrue: [ '' ]
				ifFalse: [ String streamContents: [ :s |
					each printConditionAsLeibnizSyntaxOn: s ] ] ] ].
	^ ruleView
]

{ #category : #accessing }
LzRewriteSystem >> rules [
	^ rules
]

{ #category : #accessing }
LzRewriteSystem >> rules: anOrderedCollection [
	rules := anOrderedCollection
]

{ #category : #accessing }
LzRewriteSystem >> signature [
	^ signature
]

{ #category : #accessing }
LzRewriteSystem >> signature: aSignature [
	signature := aSignature
]

{ #category : #accessing }
LzRewriteSystem >> size [
	^ self rules size
]
