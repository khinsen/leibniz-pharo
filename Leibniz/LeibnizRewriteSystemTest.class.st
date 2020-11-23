Class {
	#name : #LeibnizRewriteSystemTest,
	#superclass : #TestCase,
	#instVars : [
		'library',
		'builtins',
		'examples'
	],
	#category : #'Leibniz-4-Rules'
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

	rb := LbRewriteSystemBuilder signature: signature.
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
LeibnizRewriteSystemTest >> testEqualityTerm [
	| rws tp |

	rws := self booleanRewriteSystem.	
	tp := LbTermParser signature: rws signature.

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
	tp := LbTermParser signature: rws signature.
	test := [ :in :out | self assert: (rws reduce: (tp parse: in)) equals: (tp parse: out) ].
	
	test value: '2 × 3 × kg' value: '6 × kg'.

]

{ #category : #tests }
LeibnizRewriteSystemTest >> testReduce [
	| rws tp |

	rws := self booleanRewriteSystem.	
	tp := LbTermParser signature: rws signature.

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
	tp := LbTermParser signature: rws signature.

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
	tp := LbTermParser signature: rws signature.

	self assert: (rws rewriteLeftmostInnermost: (tp parse: '¬(true)'))
		  equals: (tp parse: 'false').
	self assert: (rws rewriteLeftmostInnermost: (tp parse: '¬(false)'))
		  equals: (tp parse: 'true').
	self assert: (rws rewriteLeftmostInnermost: (tp parse: 'foo'))
		  equals: (tp parse: '¬(false)').
	self assert: (rws rewriteLeftmostInnermost: (tp parse: '¬(¬(false))'))
		  equals: (tp parse: 'false').

]
