Class {
	#name : #LeibnizRewriteSystem,
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
LeibnizRewriteSystem class >> signature: aSignature rules: anOrderedCollection [
	^ self basicNew
			 initializeWithSignature: aSignature
								rules: anOrderedCollection;
			 yourself.

]

{ #category : #initialization }
LeibnizRewriteSystem >> initializeWithSignature: aSignature rules: anOrderedCollection [
	signature := aSignature.
	rules := anOrderedCollection.
	self beRecursivelyReadOnlyObject.

]

{ #category : #rewriting }
LeibnizRewriteSystem >> matchRulesFor: aTerm [
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
LeibnizRewriteSystem >> reduce: aTerm [
	| lastValue newValue |
	newValue := aTerm.
	lastValue := nil.
	[ lastValue = newValue ] whileFalse:
		[	lastValue := newValue.
			newValue :=  self rewriteLeftmostInnermost: lastValue ].
	^ newValue
]

{ #category : #rewriting }
LeibnizRewriteSystem >> rewriteHeadOnce: aTerm [
	self flag: #todo.
	rules do:
		[ :each |
			| s |
			s := each match: aTerm.
			s ifNotNil:
				[ (self testCondition: each condition substituting: s)
						ifTrue: [ ^ each apply: s ] ] ].
	"Special rule for term equality"
	aTerm isEqualityTerm
		ifNotNil: [ :v | ^ aTerm signature zeroArgTermNamed: (v ifTrue: #true ifFalse: #false) ].
	^ aTerm
]

{ #category : #rewriting }
LeibnizRewriteSystem >> rewriteLeftmostInnermost: aTerm [
	| reducer |
	reducer := [ :each | self reduce: each ].
	^ self rewriteHeadOnce: (aTerm withTransformedArgs: reducer)

]

{ #category : #accessing }
LeibnizRewriteSystem >> rules [
	^ rules
]

{ #category : #accessing }
LeibnizRewriteSystem >> signature [
	^ signature
]

{ #category : #rewriting }
LeibnizRewriteSystem >> testCondition: aTermOrNil substituting: aSubstitution [
	^ aTermOrNil
		ifNil: [ true ]
		ifNotNil: [ (self reduce: (aTermOrNil substitute: aSubstitution)) isTrue ]
]
