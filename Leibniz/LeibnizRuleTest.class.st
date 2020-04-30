Class {
	#name : #LeibnizRuleTest,
	#superclass : #TestCase,
	#instVars : [
		'library',
		'builtins',
		'examples',
		'currentSignature'
	],
	#category : #'Leibniz-Tests'
}

{ #category : #running }
LeibnizRuleTest >> setUp [
	super setUp.
	library := LeibnizLibrary uniqueInstance.
	builtins := library builtins.
	examples := LeibnizExamples new.
]

{ #category : #tests }
LeibnizRuleTest >> testSyntaxRoundTrip [
	| p r |
	p := LeibnizRuleParser forSignature: (examples contextNamed: 'ℝ→ℝ') signature.
	#('abs(X) ⇒ X'
	  'abs(X) ⇒ X | X ≥ 0'
	  '∀ Z:ℝ abs(Z) ⇒ Z | Z ≥ 0'
	  '∀ V:ℝ ∀ W:ℝ V + W ⇒ V'
	  '∀ V:ℝ ∀ W:ℝ V + W ⇒ V | W ≥ 0') do:
		[ :aString |
			r := p parse: aString onError: [ Error signal: 'failed to parse ', aString ].
			self assert: r asLeibnizSyntaxString equals: aString. ]

]
