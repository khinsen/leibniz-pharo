Class {
	#name : #LbRuleExamples,
	#superclass : #Object,
	#traits : 'TGtExampleAssertable',
	#classTraits : 'TGtExampleAssertable classTrait',
	#category : #'Leibniz-4-Rules'
}

{ #category : #example }
LbRuleExamples >> parserForSignatureWithVariable [
	<gtExample>
	^ LbRuleParser forSignature: self signatureWithVariable
]

{ #category : #accessing }
LbRuleExamples >> ruleSyntax [
	<gtExample>
	^ #(
		'abs(X) ⇒ X'
		'abs(X) ⇒ X | X ≥ 0'
		'∀ Z:ℤ abs(Z) ⇒ Z | Z ≥ 0'
		'∀ V:ℤ ∀ W:ℤ V + W ⇒ V'
		'∀ V:ℤ ∀ W:ℤ V + W ⇒ V | W ≥ 0')
		collect: [ :each |
			| rule |
			rule := self parserForSignatureWithVariable
				parse: each
				onError: [ Error signal: 'failed to parse ', each ].
			self assert: rule asLeibnizSyntaxString equals: each.
			each -> rule ]
]

{ #category : #example }
LbRuleExamples >> rulesWithVariables [
	<gtExample>
	| parser rule1 rule2 |
	parser := self parserForSignatureWithVariable.
	rule1 := parser parse: '∀ Z:ℤ abs(Z) ⇒ Z'.
	self
		assert: rule1 variables
		equals: (Dictionary with: #Z asLbOperatorName-> (self signatureWithVariable sortNamed: #'ℤ')).

	rule2 := parser parse: '∀ Z:ℤ abs(Z) ⇒ Z | Z > 0'.
	self
		assert: rule2 variables
		equals: (Dictionary with: #Z asLbOperatorName-> (self signatureWithVariable sortNamed: #'ℤ')).

	[ parser parse: '∀ Z:ℤ abs(X) ⇒ Z' ]
	on: Error
	do: [ :ex |
		self
			assert: ex messageText
			equals:'Variable Z in replacement but not in pattern' ].
	[ parser parse: '∀ Z:ℤ abs(Z) ⇒ Z | X > 0' ]
	on: Error
	do: [ :ex |
		self
			assert: ex messageText
			equals:'Variable X in condition but not in pattern' ].

	^ { rule1. rule2 }
]

{ #category : #example }
LbRuleExamples >> signatureWithVariable [
	<gtExample>
	| integerSignature |
	integerSignature := LbBuiltinSignatures integerSignature.
	^ (LbSignatureBuilder sortGraph: integerSignature sortGraph)
		addSignature: integerSignature includeVars: true;
		addVar: #X asLbOperatorName ofSort: (integerSignature sortGraph sortNamed: #'ℤ');
		signature.
]
