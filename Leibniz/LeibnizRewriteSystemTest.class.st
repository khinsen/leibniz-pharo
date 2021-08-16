Class {
	#name : 'LeibnizRewriteSystemTest',
	#superclass : 'TestCase',
	#instVars : [
		'library',
		'builtins',
		'examples'
	],
	#category : 'Leibniz-4-Rules'
}

{ #category : 'running' }
LeibnizRewriteSystemTest >> setUp [
	super setUp.
	library := LeibnizLibrary uniqueInstance.
	builtins := library builtins.
	examples := LeibnizExamples new.
]

{ #category : 'tests' }
LeibnizRewriteSystemTest >> testMassExample [
	| rws tp test |

	rws := (LeibnizExamples new contextNamed: 'mass-units') rewriteSystem.
	tp := LbTermParser signature: rws signature.
	test := [ :in :out | self assert: (rws reduce: (tp parse: in)) equals: (tp parse: out) ].
	
	test value: '2 × 3 × kg' value: '6 × kg'.

]
