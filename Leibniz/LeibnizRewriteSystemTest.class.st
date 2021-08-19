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

	rws := (LbContextExamples new massUnitContext) rewriteSystem.
	tp := LbParser newStartingAt:  #term.
	test := [ :in :out |
		| inTerm outTerm |
		inTerm := (tp parse: in)
					cull: rws signature
					cull: Dictionary new.
		outTerm := (tp parse: out)
					cull: rws signature
					cull: Dictionary new.
		self
			assert: (rws reduce: inTerm)
			equals: outTerm ].
	
	test value: '2 × 3 × kg' value: '6 × kg'.

]
