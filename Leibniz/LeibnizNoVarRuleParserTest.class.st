Class {
	#name : #LeibnizNoVarRuleParserTest,
	#superclass : #LeibnizParserTest,
	#category : #'Leibniz-4-Rules'
}

{ #category : #accessing }
LeibnizNoVarRuleParserTest >> parserClass [
	^ LbNoVarRuleParser
]

{ #category : #tests }
LeibnizNoVarRuleParserTest >> testNoVarRule [
	| pattern replacement expected |
	pattern := parser signature nonZeroArgTermNamed: #aOneArgOp
										 withArgs: { parser signature zeroArgTermNamed: #aZeroArgOp }.
	replacement := parser signature zeroArgTermNamed: #aZeroArgOp.
	self parse: 'aOneArgOp(aZeroArgOp) ⇒ aZeroArgOp'.
	expected := LbRewriteRule pattern: pattern replacement: replacement.
	self assert: result equals: expected.

	pattern := parser signature nonZeroArgTermNamed: #aOneArgOp
										 withArgs: { parser signature zeroArgTermNamed: #aVar }.
	self parse: 'aOneArgOp(aVar) → ''aVar'':LeibnizAtomicTerm'.
	expected := LbFunctionRule pattern: pattern function: #('aVar' #LbAtomicTerm).
	self assert: result equals: expected.
]

{ #category : #tests }
LeibnizNoVarRuleParserTest >> testNoVarRuleWithCondition [
	| pattern replacement trueTerm |
	pattern := parser signature nonZeroArgTermNamed: #aOneArgOp
										 withArgs: { parser signature zeroArgTermNamed: #aZeroArgOp }.
	replacement := parser signature zeroArgTermNamed: #aZeroArgOp.
	trueTerm := parser signature zeroArgTermNamed: #true.
	self parse: 'aOneArgOp(aZeroArgOp) ⇒ aZeroArgOp | true'.
	self assert: result
		  equals: (LbRewriteRule pattern: pattern condition: trueTerm replacement: replacement).

]

{ #category : #tests }
LeibnizNoVarRuleParserTest >> testSyntaxRoundTrip [
	#(	'aOneArgOp(aZeroArgOp) ⇒ aZeroArgOp'
		'aOneArgOp(aVar) → ''aVar'':LeibnizStringTerm' ) do:
		[ :rule | self parse: rule. self assert: result asLeibnizSyntaxString equals: rule ]

]
