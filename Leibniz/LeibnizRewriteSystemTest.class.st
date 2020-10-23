Class {
	#name : #LeibnizRewriteSystemTest,
	#superclass : #TestCase,
	#instVars : [
		'library',
		'builtins',
		'examples'
	],
	#category : #'Leibniz-Tests'
}

{ #category : #running }
LeibnizRewriteSystemTest >> booleanRewriteSystem [
	| booleanContext sb signature rb |

	booleanContext := examples contextNamed: 'boolean'.
	sb := LbSignatureBuilder sortGraph: booleanContext sortGraph.
	sb addSignature: booleanContext signature includeVars: false.
	sb addOp: #foo ofSort: #boolean.
	sb addOp: #bar ofSort: #boolean.
	sb addVar: #X ofSort: #boolean.
	signature := sb signature.

	rb := LeibnizRewriteSystemBuilder signature: signature.
	self should: [ rb parseAndAddRule: 'True ⇒ False' ] raise: Error.
	rb parseAndAddRule: '¬(true) ⇒ false'.
	rb parseAndAddRule: '¬(false) ⇒ true'.
	rb parseAndAddRule: 'foo ⇒ ¬(true) | false'.
	rb parseAndAddRule: 'foo ⇒ ¬(false) | true'.
	^ rb rewriteSystem.
]

{ #category : #running }
LeibnizRewriteSystemTest >> setUp [
	super setUp.
	library := LeibnizLibrary uniqueInstance.
	builtins := library builtins.
	examples := LeibnizExamples new.
]

{ #category : #tests }
LeibnizRewriteSystemTest >> testBooleanExample [
	| rws tp test |

	rws := (LeibnizExamples new contextNamed: #boolean) rewriteSystem.
	tp := LbTermParser forSignature: rws signature.
	test := [ :in :out | self assert: (rws reduce: (tp parse: in)) equals: (tp parse: out) ].
	
	"Note: the truth tabels may seem like trivial tests for rewriting,
	but the actual rules in the boolean context are in fact quite sophisticated."

	test value: '¬(true)' value: 'false'.
	test value: '¬(false)' value: 'true'.

	test value: 'false ∧ false' value: 'false'.
	test value: 'false ∧ true' value: 'false'.
	test value: 'true ∧ false' value: 'false'.
	test value: 'true ∧ true' value: 'true'.

	test value: 'false ∨ false' value: 'false'.
	test value: 'false ∨ true' value: 'true'.
	test value: 'true ∨ false' value: 'true'.
	test value: 'true ∨ true' value: 'true'.

	test value: 'false ⊻ false' value: 'false'.
	test value: 'false ⊻ true' value: 'true'.
	test value: 'true ⊻ false' value: 'true'.
	test value: 'true ⊻ true' value: 'false'.

]

{ #category : #tests }
LeibnizRewriteSystemTest >> testEqualityTerm [
	| rws tp |

	rws := self booleanRewriteSystem.	
	tp := LbTermParser forSignature: rws signature.

	self assert: (rws rewriteHeadOnce: (tp parse: 'true == true'))
		  equals: (tp parse: 'true').
	self assert: (rws rewriteHeadOnce: (tp parse: 'true == false'))
		  equals: (tp parse: 'false').
	self assert: (rws rewriteHeadOnce: (tp parse: '¬(true) == false'))
		  equals: (tp parse: 'false').
	self assert: (rws reduce: (tp parse: '¬(true) == false'))
		  equals: (tp parse: 'true').

]

{ #category : #tests }
LeibnizRewriteSystemTest >> testMassExample [
	| rws tp test |

	rws := (LeibnizExamples new contextNamed: 'mass-units') rewriteSystem.
	tp := LbTermParser forSignature: rws signature.
	test := [ :in :out | self assert: (rws reduce: (tp parse: in)) equals: (tp parse: out) ].
	
	test value: '2 × 3 × kg' value: '6 × kg'.

]

{ #category : #tests }
LeibnizRewriteSystemTest >> testReduce [
	| rws tp |

	rws := self booleanRewriteSystem.	
	tp := LbTermParser forSignature: rws signature.

	self assert: (rws reduce: (tp parse: '¬(true)'))
		  equals: (tp parse: 'false').
	self assert: (rws reduce: (tp parse: '¬(false)'))
		  equals: (tp parse: 'true').
	self assert: (rws reduce: (tp parse: 'foo'))
		  equals: (tp parse: 'true').
	self assert: (rws reduce: (tp parse: '¬(¬(false))'))
		  equals: (tp parse: 'false').

]

{ #category : #tests }
LeibnizRewriteSystemTest >> testRewriteHeadOnce [
	| rws tp |

	rws := self booleanRewriteSystem.	
	tp := LbTermParser forSignature: rws signature.

	self assert: (rws rewriteHeadOnce: (tp parse: '¬(true)'))
		  equals: (tp parse: 'false').
	self assert: (rws rewriteHeadOnce: (tp parse: '¬(false)'))
		  equals: (tp parse: 'true').
	self assert: (rws rewriteHeadOnce: (tp parse: 'foo'))
		  equals: (tp parse: '¬(false)').
	self assert: (rws rewriteHeadOnce: (tp parse: '¬(¬(false))'))
		  equals: (tp parse: '¬(¬(false))').

]

{ #category : #tests }
LeibnizRewriteSystemTest >> testRewriteLeftMostInntermost [
	| rws tp |

	rws := self booleanRewriteSystem.	
	tp := LbTermParser forSignature: rws signature.

	self assert: (rws rewriteLeftmostInnermost: (tp parse: '¬(true)'))
		  equals: (tp parse: 'false').
	self assert: (rws rewriteLeftmostInnermost: (tp parse: '¬(false)'))
		  equals: (tp parse: 'true').
	self assert: (rws rewriteLeftmostInnermost: (tp parse: 'foo'))
		  equals: (tp parse: '¬(false)').
	self assert: (rws rewriteLeftmostInnermost: (tp parse: '¬(¬(false))'))
		  equals: (tp parse: 'false').

]
