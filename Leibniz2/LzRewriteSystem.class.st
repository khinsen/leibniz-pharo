Class {
	#name : #LzRewriteSystem,
	#superclass : #Object,
	#traits : 'TLzEquality',
	#classTraits : 'TLzEquality classTrait',
	#instVars : [
		'rules',
		'signature',
		'ruleDeclarations'
	],
	#category : #'Leibniz2-Rules'
}

{ #category : #inspecting }
LzRewriteSystem >> gtRulesFor: aView [
	<gtView>
	| ruleView topLevel label |
	topLevel := [ :object |
		object isSymbol or: [ object isKindOf: LzOpName] ].
	label := [ :object |
		object isSymbol ifTrue: [ object ] ifFalse: [ object synopsis ] ].
	ruleView := aView columnedTree
		title: 'Rules';
		priority: 1;
		items: [ rules keys sorted ];
		children: [ :each |
			(topLevel value: each)
				ifTrue: [ rules at: each ]
				ifFalse: [ #() ] ];
		column: 'Variables' lzCode: [ :each |
			(topLevel value: each)
				ifTrue: [ label value: each ]
				ifFalse: [ String streamContents: [ :s |
					each printVariablesAsLeibnizSyntaxOn: s ] ] ];
		column: 'Transformation' lzCode: [ :each |
			(topLevel value: each)
				ifTrue: [ '' ]
				ifFalse: [ String streamContents: [ :s |
					each printBodyAsLeibnizSyntaxOn: s ] ] ];
		yourself.
	self hasConditionalRule ifTrue: [
		ruleView column: 'Condition' lzCode: [ :each |
			(topLevel value: each)
				ifTrue: [ '' ]
				ifFalse: [ String streamContents: [ :s |
					each printConditionAsLeibnizSyntaxOn: s ] ] ] ].
	^ ruleView
]

{ #category : #testing }
LzRewriteSystem >> hasConditionalRule [
	rules valuesDo: [ :eachRuleList |
		eachRuleList
			detect: [ :eachRule | eachRule condition isNotNil ]
			ifFound: [ ^ true ] ].
	^ false
]

{ #category : #testing }
LzRewriteSystem >> isEmpty [
	^ rules isEmpty
]

{ #category : #rewriting }
LzRewriteSystem >> reduce: aTerm [
	| lastValue newValue |
	self assert: aTerm signature equals: signature.
	newValue := aTerm.
	lastValue := nil.
	[ lastValue = newValue ] whileFalse: [
		lastValue := newValue.
		newValue :=  self rewriteLeftmostInnermost: lastValue ].
	^ lastValue
]

{ #category : #accessing }
LzRewriteSystem >> referenceSlots [
	^ #(signature)
]

{ #category : #rewriting }
LzRewriteSystem >> rewriteHeadOnce: aTerm [
	(rules at: aTerm fingerprint ifAbsent: [ #() ]) do: [ :aRule |
		| reducer bindings |
		self flag: #todo. "Use matchAllowingVars: ?"
		"bindings := aRule pattern matchAllowingVars: aTerm."
		reducer := [ :t | self reduce: t ].
		bindings := LzBindings new
						sortGraph: self signature sortGraph.
		aRule pattern match: aTerm bindings: bindings.
		bindings ifSuccess: [ :s |
			[ (aRule
				testConditionForSubstitution: s
				reducer: reducer)
				ifTrue: [ ^ aRule apply: s reducer: reducer ] ]
			on: LzRewriteFailure do: [  ] ] ].
	"If no rule matches, return the input term"
	^ aTerm
]

{ #category : #rewriting }
LzRewriteSystem >> rewriteLeftmostInnermost: aTerm [
	| transformedArgs |
	transformedArgs := aTerm args collect: [ :each | self reduce: each ].
	^ self rewriteHeadOnce: (aTerm withTransformedArgs: transformedArgs)
]

{ #category : #accessing }
LzRewriteSystem >> ruleDeclarations [
	^ ruleDeclarations
]

{ #category : #accessing }
LzRewriteSystem >> ruleDeclarations: aCollection [
	ruleDeclarations := aCollection
]

{ #category : #accessing }
LzRewriteSystem >> rules [
	^ rules
]

{ #category : #accessing }
LzRewriteSystem >> rules: anOrderedCollection [
	"Classify rules by a pattern fingerprint, to avoid scanning the full
	 rule list when matching terms. The fingerprint is the top-level operator
	 name for op terms, #var for variables, and #atomic for atomic terms.
	 Treat #var as a special case because a variable can match terms
	 of any fingerprint."
	rules := Dictionary with: #var -> OrderedCollection  new.
	anOrderedCollection do: [ :each |
		| fp |
		fp := each pattern fingerprint.
		fp = #var
			ifTrue: [
				rules do: [ :eachRuleList | eachRuleList add: each ] ]
			ifFalse: [
				(rules at: fp ifAbsentPut: [ (rules at: #var) copy ])
					add: each. ] ].
	rules removeKey: #var.
]

{ #category : #rewriting }
LzRewriteSystem >> rulesMatching: aTerm [
	^LzMatchingRules new
		rewriteSystem: self;
		term: aTerm;
		match
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

{ #category : #accessing }
LzRewriteSystem >> valueSlots [
	^ #(rules)
]
