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

{ #category : #inspecting }
LbRewriteSystem >> gtRulesFor: aView [
	<gtView>
	| ruleView |
	ruleView := aView columnedList
		title: 'Rules' translated;
		priority: 1;
		items: [ rules ];
		column: 'Variables' lbCode: [ :each |
			String streamContents: [ :s |
				each printVariablesAsLeibnizSyntaxOn: s ] ];
		column: 'Transformation' lbCode: [ :each |
			String streamContents: [ :s |
				each printBodyAsLeibnizSyntaxOn: s ] ];
		yourself.
	self hasRuleWithCondition ifTrue: [
		ruleView column: 'Condition' lbCode: [ :each |
			String streamContents: [ :s |
				each printConditionAsLeibnizSyntaxOn: s ] ] ].
	^ ruleView
]

{ #category : #testing }
LbRewriteSystem >> hasRuleWithCondition [
	^ rules detect: [ :each | each condition isNotNil ]
		ifFound: [ true ] ifNone: [ false ]
]

{ #category : #initialization }
LbRewriteSystem >> initializeWithSignature: aSignature rules: anOrderedCollection [
	signature := aSignature.
	rules := anOrderedCollection.
	self beRecursivelyReadOnlyObject.

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
	[ lastValue = newValue ] whileFalse:
		[	lastValue := newValue.
			newValue :=  self rewriteLeftmostInnermost: lastValue ].
	^ newValue
]

{ #category : #rewriting }
LbRewriteSystem >> rewriteHeadOnce: aTerm [
	rules do: [ :each |
		(each pattern match: aTerm) ifNotNil: [ :s |
			[ (self testCondition: each condition substituting: s)
				ifTrue: [ ^ each apply: s ] ]
			on: LbRewriteFailure do: [  ] ] ].
	"Special rule for term equality"
	aTerm evaluateEqualityTerm ifNotNil: [ :value |
		^ LbBooleanTerm value: value signature: aTerm signature ].
	^ aTerm
]

{ #category : #rewriting }
LbRewriteSystem >> rewriteLeftmostInnermost: aTerm [
	| reducer |
	reducer := [ :each | self reduce: each ].
	^ self rewriteHeadOnce: (aTerm withTransformedArgs: reducer)

]

{ #category : #accessing }
LbRewriteSystem >> rules [
	^ rules
]

{ #category : #rewriting }
LbRewriteSystem >> rulesMatching: aTerm [
	| matches |
	matches := LbMatchingRules new
					rewriteSystem: self;
					term: aTerm.
	rules do: [ :each |
		(each pattern match: aTerm)
			ifNil: [ matches addNonMatchingRule: each ]
			ifNotNil: [ :s |
				(self testCondition: each condition substituting: s)
					ifFalse: [ matches addMatchingRuleFailedCondition: each ]
					ifTrue: [ matches addMatchingRule: each result: (each apply: s) ] ] ].
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
