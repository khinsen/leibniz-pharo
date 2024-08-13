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

{ #category : #copying }
LzRewriteSystem >> copy [
	^ self
]

{ #category : #copying }
LzRewriteSystem >> deepCopy [
	^ self
]

{ #category : #inspecting }
LzRewriteSystem >> gtRulesFor: aView [
	<gtView>
	| ruleView topLevel label |
	topLevel := [ :object |
		object isSymbol or: [ object isKindOf: LzOpName] ].
	label := [ :object |
		(object isSymbol
			ifTrue: [ object ]
			ifFalse: [ object synopsis ])
			asRopedText fontName: LzCodeFont defaultFamily ].
	ruleView := aView columnedTree
		title: 'Rules';
		priority: 1;
		items: [ rules keys sorted ];
		children: [ :each |
			(topLevel value: each)
				ifTrue: [ rules at: each ]
				ifFalse: [ #() ] ].
	ruleView
		column: 'Variables' text: [ :each |
			(topLevel value: each)
				ifTrue: [ label value: each ]
				ifFalse: [
					LzCodeFont textFrom: [ :t |
						each addVariablesAsRopedTextTo: t ] ] ];
		column: 'Transformation' text: [ :each |
			(topLevel value: each)
				ifTrue: [ '' ]
				ifFalse: [
					LzCodeFont textFrom: [ :t |
						each addBodyAsRopedTextTo: t ] ] ].
	self hasConditionalRule ifTrue: [
		ruleView column: 'Condition' text: [ :each |
			(topLevel value: each)
				ifTrue: [ '' ]
				ifFalse: [
					LzCodeFont textFrom: [ :t |
						each addConditionAsRopedTextTo: t ] ] ] ].
	self hasLabeledRule ifTrue: [
		ruleView column: 'Label' text: [ :each |
			(topLevel value: each)
				ifTrue: [ '' ]
				ifFalse: [
					LzCodeFont textFrom: [ :t |
						each addLabelAsRopedTextTo: t ] ] ] ].
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
LzRewriteSystem >> hasLabeledRule [
	rules valuesDo: [ :eachRuleList |
		eachRuleList
			detect: [ :eachRule | eachRule label isNotNil ]
			ifFound: [ ^ true ] ].
	^ false
]

{ #category : #testing }
LzRewriteSystem >> isEmpty [
	^ rules isEmpty
]

{ #category : #testing }
LzRewriteSystem >> randomizeRuleOrder [
	"Meant for testing that rule order does not matter."
	rules valuesDo: [ :eachRuleList | eachRuleList shuffle ]
]

{ #category : #rewriting }
LzRewriteSystem >> reduce: aTerm [
	| lastValue newValue |
	self assert: aTerm signature equals: signature.
	newValue := aTerm.
	lastValue := nil.
	[ lastValue = newValue ] whileFalse: [
		lastValue := newValue.
		newValue :=  self
						rewriteLeftmostInnermost: lastValue
						reducer: [ :t | self reduce: t ]].
	^ lastValue
]

{ #category : #accessing }
LzRewriteSystem >> referenceSlots [
	^ #(signature)
]

{ #category : #rewriting }
LzRewriteSystem >> rewriteHeadOnce: aTerm reducer: aBlock [
	(rules at: aTerm fingerprint ifAbsent: [ #() ]) do: [ :aRule |
		| bindings |
		self flag: #todo. "Use matchAllowingVars: ?"
		"bindings := aRule pattern matchAllowingVars: aTerm."
		bindings := self signature emptyBindings.
		aRule pattern match: aTerm bindings: bindings.
		bindings ifSuccess: [ :s |
			[ (aRule
				testConditionForSubstitution: s
				reducer: aBlock)
				ifTrue: [ ^ aRule apply: s reducer: aBlock ] ]
			on: LzRewriteFailure do: [  ] ] ].
	"If no rule matches, return the input term"
	^ aTerm
]

{ #category : #rewriting }
LzRewriteSystem >> rewriteLeftmostInnermost: aTerm reducer: aBlock [
	| args transformedArgs |
	args := aTerm args.
	transformedArgs := args collect: aBlock.
	^ self
		rewriteHeadOnce: (transformedArgs = args
							ifTrue: [ aTerm ]
							ifFalse: [ aTerm withTransformedArgs: transformedArgs ])
		reducer: aBlock
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

{ #category : #initializing }
LzRewriteSystem >> rules: aCollection [
	"Classify rules by a pattern fingerprint, to avoid scanning the full
	 rule list when matching terms. The fingerprint is the top-level operator
	 name for op terms, #var for variables, and #atomic for atomic terms.
	 Treat #var as a special case because a variable can match terms
	 of any fingerprint."
	rules := Dictionary with: #var -> OrderedCollection  new.
	aCollection do: [ :each |
		| fp |
		fp := each pattern fingerprint.
		fp = #var
			ifTrue: [
				rules do: [ :eachRuleList | eachRuleList add: each ] ]
			ifFalse: [
				(rules at: fp ifAbsentPut: [ (rules at: #var) copy ])
					add: each. ] ].
	rules removeKey: #var.
	self sortLabeledRules.
]

{ #category : #rewriting }
LzRewriteSystem >> rulesMatching: aTerm [
	^LzMatchingRules new
		rewriteSystem: self;
		term: aTerm;
		match;
		sort
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

{ #category : #initializing }
LzRewriteSystem >> sortLabeledRules [
	rules := rules collect: [ :eachRuleList |
		| labeledRules |
		labeledRules := eachRuleList groupedBy: [ :each |
			each label isNotNil and: each order isNotNil ].
		((labeledRules at: true ifAbsent: [ #() ]) sort: [ :a :b | a sortsBefore: b ]),
			(labeledRules at: false ifAbsent: [ #() ]) ]
]

{ #category : #accessing }
LzRewriteSystem >> valueSlots [
	^ #(rules)
]
