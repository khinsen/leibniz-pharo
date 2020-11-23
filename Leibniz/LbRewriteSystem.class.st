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
	"String streamContents: [ :s | self printAsLeibnizSyntaxOn: s ] "
	^ aView columnedList
		title: 'Rules' translated;
		priority: 1;
		items: [ rules ];
		column: 'Variables' lbCode: [ :each |
			String streamContents: [ :s |
				each printVariablesAsLeibnizSyntaxOn: s ] ];
		column: 'Transformation' lbCode: [ :each |
			String streamContents: [ :s |
				each printBodyAsLeibnizSyntaxOn: s ] ];
		column: 'Condition' lbCode: [ :each |
			String streamContents: [ :s |
				each printConditionAsLeibnizSyntaxOn: s ] ];
		yourself
]

{ #category : #initialization }
LbRewriteSystem >> initializeWithSignature: aSignature rules: anOrderedCollection [
	signature := aSignature.
	rules := anOrderedCollection.
	self beRecursivelyReadOnlyObject.

]

{ #category : #rewriting }
LbRewriteSystem >> matchRulesFor: aTerm [
	^ rules collect:
		[ :each |
			| s c r |
			s := each pattern match: aTerm.
			s ifNotNil:
			  [ c := self testCondition: each condition substituting: s.
			    r := (c ifTrue: (each apply: s) ifFalse: nil).
				 Dictionary with: #rule -> each
								with: #substitution -> s
								with: #condition -> c
								with: #result -> r ] ]
		thenReject: [ :each | each isNil ]
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
	self flag: #todo.
	rules do:
		[ :each |
			| s |
			s := each match: aTerm.
			s ifNotNil:
				[ [ (self testCondition: each condition substituting: s)
						ifTrue: [ ^ each apply: s ] ]
						on: LbRewriteFailure do: [  ] ] ].
	"Special rule for term equality"
	aTerm isEqualityTerm
		ifNotNil: [ :v | ^ aTerm signature zeroArgTermNamed: (v ifTrue: #true ifFalse: #false) ].
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

{ #category : #accessing }
LbRewriteSystem >> signature [
	^ signature
]

{ #category : #rewriting }
LbRewriteSystem >> testCondition: aTermOrNil substituting: aSubstitution [
	^ aTermOrNil
		ifNil: [ true ]
		ifNotNil: [ (self reduce: (aTermOrNil substitute: aSubstitution)) isTrue ]
]
