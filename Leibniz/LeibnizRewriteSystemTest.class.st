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
LeibnizRewriteSystemTest >> setUp [
	super setUp.
	library := LeibnizLibrary uniqueInstance.
	builtins := library builtins.
	examples := LeibnizExamples new.
]

{ #category : #tests }
LeibnizRewriteSystemTest >> testBooleanRules [
	| booleanContext sb signature rb rws tp |

	booleanContext := examples contextNamed: 'boolean'.
	sb := LeibnizSignatureBuilder sortGraph: booleanContext sortGraph.
	sb addSignature: booleanContext signature includeVars: false.
	sb addOp: #foo ofSort: #boolean.
	sb addOp: #bar ofSort: #boolean.
	signature := sb signature.

	rb := LeibnizRewriteSystemBuilder signature: signature.
	rb parseAndAddRule: '¬(true) ⇒ false'.
	rb parseAndAddRule: '¬(false) ⇒ true'.
	rb parseAndAddRule: 'foo ⇒ ¬(true) | false'.
	rb parseAndAddRule: 'foo ⇒ ¬(false) | true'.
	rws := rb rewriteSystem.

	tp := LeibnizTermParser forSignature: signature.

	self assert: (rws rewriteHeadOnce: (tp parse: '¬(true)'))
		  equals: (tp parse: 'false').
	self assert: (rws rewriteHeadOnce: (tp parse: '¬(false)'))
		  equals: (tp parse: 'true').
	self assert: (rws rewriteHeadOnce: (tp parse: '¬(¬(false))'))
		  equals: (tp parse: '¬(¬(false))').
	self assert: (rws rewriteHeadOnce: (tp parse: 'foo'))
		  equals: (tp parse: '¬(false)').

]
