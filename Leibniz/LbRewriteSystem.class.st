Class {
	#name : #LbRewriteSystem,
	#superclass : #Object,
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'signature',
		'rules'
	],
	#category : #'Leibniz-4-Rules'
}

{ #category : #'instance creation' }
LbRewriteSystem class >> signature: aSignature rules: anOrderedCollection [
	^ self basicNew
			 initializeWithSignature: aSignature
								rules: anOrderedCollection;
			 yourself.

]

{ #category : #accessing }
LbRewriteSystem >> allDeclarations [
	^ self signature declarations union: self declarations
]

{ #category : #accessing }
LbRewriteSystem >> declarations [
	| ruleDecls |
	ruleDecls := OrderedCollection new.
	rules keys sorted do: [ :eachHeadOpName |
		(rules at: eachHeadOpName) do: [ :eachRule |
			| decl |
			decl := eachRule asLeibnizSyntaxString.
			(ruleDecls includes: decl)
				ifFalse: [ ruleDecls add: decl ] ] ].
	^ Dictionary with: #rules -> ruleDecls
]

{ #category : #inspecting }
LbRewriteSystem >> gtDeclarationsFor: aView [
	<gtView>
	^ aView lbTree
		title: 'Declarations' translated;
		priority: 4;
		items: [ | d categories |
			d := self allDeclarations.
			categories := OrderedCollection new.
			#(sorts subsorts variables operators rules) do: [ :each |
				(d at: each) ifNotEmpty: [
					categories add: {
						each asString capitalized.
						(d at: each) collect: [ :aString |
							{ aString. #() } ] } ] ].
			categories ];
		itemLbCode: #first;
		children: #second;
		send: #first;
		collapseAll;
		expandItems: #('Rules');
		yourself
]

{ #category : #inspecting }
LbRewriteSystem >> gtRulesFor: aView [
	<gtView>
	| ruleView |
	ruleView := aView columnedTree
		title: 'Rules' translated;
		priority: 1;
		items: [ rules keys sorted ];
		children: [ :each |
			(each isKindOf: LbOperatorName)
				ifTrue: [ rules at: each ]
				ifFalse: [ #() ] ];
		column: 'Variables' lbCode: [ :each |
			(each isKindOf: LbOperatorName)
				ifTrue: [ each synopsis ]
				ifFalse: [ String streamContents: [ :s |
					each printVariablesAsLeibnizSyntaxOn: s ] ] ];
		column: 'Transformation' lbCode: [ :each |
			(each isKindOf: LbOperatorName)
				ifTrue: [ '' ]
				ifFalse: [ String streamContents: [ :s |
					each printBodyAsLeibnizSyntaxOn: s ] ] ];
		yourself.
	self hasRuleWithCondition ifTrue: [
		ruleView column: 'Condition' lbCode: [ :each |
			(each isKindOf: LbOperatorName)
				ifTrue: [ '' ]
				ifFalse: [ String streamContents: [ :s |
					each printConditionAsLeibnizSyntaxOn: s ] ] ] ].
	^ ruleView
]

{ #category : #testing }
LbRewriteSystem >> hasRuleWithCondition [
	rules valuesDo: [ :eachRuleList |
		eachRuleList
			detect: [ :eachRule | eachRule condition isNotNil ]
			ifFound: [ ^ true ] ].
	^ false
]

{ #category : #initialization }
LbRewriteSystem >> initializeWithSignature: aSignature rules: anOrderedCollection [
	| varHeadOp |
	signature := aSignature.
	"Classify rules by headOpName, to avoid scanning the full rule list
	 when matching terms. Treat #Variable as a special case because a
	 variable can match terms of any headOpName."
	varHeadOp := LbPseudoOperatorName for: #Variable.
	rules := Dictionary with: varHeadOp -> OrderedCollection new.
	anOrderedCollection do: [ :each |
		| head |
		head := each pattern headOpName.
		head = varHeadOp
			ifTrue: [
				rules do: [ :eachRuleList | eachRuleList add: each ] ]
			ifFalse: [
				(rules at: head ifAbsentPut: [ (rules at: varHeadOp) copy ])
					add: each. ] ].
	rules removeKey: varHeadOp.
	self beRecursivelyReadOnlyObject.
]

{ #category : #testing }
LbRewriteSystem >> isEmpty [
	^ rules isEmpty
]

{ #category : #rewriting }
LbRewriteSystem >> parseAndReduce: aString [
	^ self reduce: (signature parseTerm: aString)
]

{ #category : #rewriting }
LbRewriteSystem >> parseAndRewriteHeadOnce: aString [
	^ self rewriteHeadOnce: (signature parseTerm: aString)
]

{ #category : #rewriting }
LbRewriteSystem >> parseAndRewriteLeftmostInnermost: aString [
	^ self rewriteLeftmostInnermost: (signature parseTerm: aString)
]

{ #category : #rewriting }
LbRewriteSystem >> reduce: aTerm [
	| lastValue newValue |
	newValue := aTerm.
	lastValue := nil.
	[ lastValue = newValue ] whileFalse: [
		lastValue := newValue.
		newValue :=  self rewriteLeftmostInnermost: lastValue ].
	^ lastValue
]

{ #category : #rewriting }
LbRewriteSystem >> reductionStepsFor: aTerm [
	^ LbReductionSteps new
		rewriteSystem: self;
		term: aTerm
]

{ #category : #rewriting }
LbRewriteSystem >> rewriteHeadOnce: aTerm [
	(rules at: aTerm headOpName ifAbsent: [ #() ]) do: [ :aRule |
		(aRule pattern match: aTerm) ifSuccess: [ :s |
			[ (self testCondition: aRule condition substituting: s)
				ifTrue: [ ^ aRule apply: s ] ]
			on: LbRewriteFailure do: [  ] ] ].
	"Special rule for term equality"
	aTerm evaluateEqualityTerm ifNotNil: [ :value |
		^ LbBooleanTerm value: value signature: aTerm signature ].
	"If no rule matches, return the input term"
	^ aTerm
]

{ #category : #rewriting }
LbRewriteSystem >> rewriteLeftmostInnermost: aTerm [
	| transformedArgs |
	transformedArgs := aTerm arguments collect: [ :each | self reduce: each ].
	^ self rewriteHeadOnce: (aTerm withTransformedArgs: transformedArgs)
]

{ #category : #accessing }
LbRewriteSystem >> rules [
	^ rules
]

{ #category : #rewriting }
LbRewriteSystem >> rulesMatching: aTerm [
	| matches testRule |
	matches := LbMatchingRules new
					rewriteSystem: self;
					term: aTerm.
	(rules at: aTerm headOpName ifAbsent: [ #() ]) do: [ :aRule |
		(aRule pattern match: aTerm)
			ifSuccess: [ :s |
				(self testCondition: aRule condition substituting: s)
					ifFalse: [ matches addMatchingRuleFailedCondition: aRule ]
					ifTrue: [ matches addMatchingRule: aRule result: (aRule apply: s) ] ]
			ifFailure: [ matches addNonMatchingRule: aRule ] ].
	^ matches
]

{ #category : #accessing }
LbRewriteSystem >> signature [
	^ signature
]

{ #category : #rewriting }
LbRewriteSystem >> testCondition: aTermOrNil substituting: aSubstitution [
	aTermOrNil ifNil: [ ^ true ].
	[ ^ (self reduce: (aTermOrNil substitute: aSubstitution)) isTrue ]
	on: LbRewriteFailure do: [ ^ false ]
]
