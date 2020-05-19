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

{ #category : #tests }
LeibnizRuleTest >> testVariables [
	| p r |
	p := LeibnizRuleParser forSignature: (examples contextNamed: 'ℝ→ℝ') signature.
	self shouldnt: [ r := p parse: '∀ Z:ℝ abs(Z) ⇒ Z' ] raise: AssertionFailure.
	self assert: r variables equals: (Dictionary with: #Z -> #'ℝ').
	self should: [ p parse: '∀ Z:ℝ abs(X) ⇒ Z' ]
		  raise: AssertionFailure whoseDescriptionIncludes: 'Variable Z in replacement but not in pattern'
		  description: ''.
	self shouldnt: [ r := p parse: '∀ Z:ℝ abs(Z) ⇒ Z | Z > 0' ] raise: AssertionFailure. 
	self assert: r variables equals: (Dictionary with: #Z -> #'ℝ').
	self should: [ p parse: '∀ Z:ℝ abs(Z) ⇒ Z | X > 0' ]
		  raise: AssertionFailure whoseDescriptionIncludes: 'Variable X in condition but not in pattern'
		  description: ''.

]
