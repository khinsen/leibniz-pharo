Class {
	#name : #LeibnizNoVarRuleParserTest,
	#superclass : #LeibnizParserTest,
	#category : #'Leibniz-Tests'
}

{ #category : #accessing }
LeibnizNoVarRuleParserTest >> parserClass [
	^ LeibnizNoVarRuleParser
]

{ #category : #tests }
LeibnizNoVarRuleParserTest >> testNoVarRule [
	| pattern replacement |
	pattern := parser signature nonZeroArgTermNamed: #aOneArgOp
										 withArgs: { parser signature zeroArgTermNamed: #aZeroArgOp }.
	replacement := parser signature zeroArgTermNamed: #aZeroArgOp.
	self parse: 'aOneArgOp(aZeroArgOp) ⇒ aZeroArgOp'.
	self assert: result
		  equals: (LeibnizRewriteRule pattern: pattern replacement: replacement).

	pattern := parser signature nonZeroArgTermNamed: #aOneArgOp
										 withArgs: { parser signature zeroArgTermNamed: #aVar }.
	self parse: 'aOneArgOp(aVar) → ''aVar'''.
	self assert: result
		  equals: (LeibnizFunctionRule pattern: pattern function: 'aVar').

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
		  equals: (LeibnizRewriteRule pattern: pattern condition: trueTerm replacement: replacement).

]

{ #category : #tests }
LeibnizNoVarRuleParserTest >> testSyntaxRoundTrip [
	#(	'aOneArgOp(aZeroArgOp) ⇒ aZeroArgOp'
		'aOneArgOp(aVar) → ''aVar'':LeibnizStringTerm' ) do:
		[ :rule | self parse: rule. self assert: result asLeibnizSyntaxString equals: rule ]

]
