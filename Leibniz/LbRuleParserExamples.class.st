Class {
	#name : 'LbRuleParserExamples',
	#superclass : 'Object',
	#traits : 'TGtExampleAssertable',
	#classTraits : 'TGtExampleAssertable classTrait',
	#category : 'Leibniz-4-Rules'
}

{ #category : 'example' }
LbRuleParserExamples >> noVarRule [
	<gtExample>
	| pattern replacement expected rule1 rule2 |
	rule1 := self parseAsRule: 'aOneArgOp(aZeroArgOp) ⇒ aZeroArgOp'.
	pattern := self parseAsTerm: 'aOneArgOp(aZeroArgOp)'.
	replacement := self parseAsTerm: 'aZeroArgOp'.
	expected := LbRewriteRule pattern: pattern replacement: replacement.
	self assert: rule1 equals: expected.

	rule2 := self parseAsRule: 'aOneArgOp(aVar) → ''aVar'':LeibnizAtomicTerm'.
	pattern := self parseAsTerm: 'aOneArgOp(aVar)'.
	expected := LbFunctionRule pattern: pattern function: #('aVar' #LbAtomicTerm).
	self assert: rule2 equals: expected.

	^ { rule1. rule2 }
]

{ #category : 'example' }
LbRuleParserExamples >> noVarRuleSyntax [
	<gtExample>
	^ #(
		'aOneArgOp(aZeroArgOp) ⇒ aZeroArgOp'
		'aOneArgOp(aVar) → ''aVar'':LeibnizStringTerm'
	) collect: [ :each |
		| rule |
		rule := self parseAsRule: each.
		self assert: rule asLeibnizSyntaxString equals: each.
		rule ]
]

{ #category : 'accessing' }
LbRuleParserExamples >> noVarRuleWithCondition [
	<gtExample>
	| pattern replacement trueTerm rule |
	pattern := self parseAsTerm: 'aOneArgOp(aZeroArgOp)'.
	replacement := self parseAsTerm: 'aZeroArgOp'.
	trueTerm := self parseAsTerm: 'true'.
	rule := self parseAsRule: 'aOneArgOp(aZeroArgOp) ⇒ aZeroArgOp | true'.
	self
		assert: rule
		equals: (LbRewriteRule
					pattern: pattern
					condition: trueTerm
					replacement: replacement).
	^ rule
]

{ #category : 'parsing' }
LbRuleParserExamples >> parseAsRule: aString [
	^ ((LbParser newStartingAt: #rule) parse: aString)
		cull: self signature
]

{ #category : 'parsing' }
LbRuleParserExamples >> parseAsTerm: aString [
	^ ((LbParser newStartingAt: #term) parse: aString)
		cull: self signature cull: Dictionary new
]

{ #category : 'example' }
LbRuleParserExamples >> ruleWithVariable [
	<gtExample>
	| extraVariables pattern replacement referenceRule parsedRule |
	extraVariables := Dictionary with: #X asLbOperatorName-> (self signature sortNamed: #A).
	pattern := self signature
				nonZeroArgTermNamed: #aOneArgOp asLbOperatorName
				withArgs: { self signature
								zeroArgTermNamed: #X asLbOperatorName
								extraVariables: extraVariables }.
	replacement := self signature zeroArgTermNamed: #aZeroArgOp asLbOperatorName.
	referenceRule := LbRewriteRule pattern: pattern localVariables: extraVariables replacement: replacement.
	parsedRule := self parseAsRule: '∀ X:A aOneArgOp(X) ⇒ aZeroArgOp'.
	self assert: parsedRule equals: referenceRule.
	^ parsedRule
]

{ #category : 'example' }
LbRuleParserExamples >> ruleWithVariableAndCondition [
	<gtExample>
	| extraVariables pattern replacement referenceRule parsedRule trueTerm |
	extraVariables := Dictionary
		with: #X asLbOperatorName -> (self signature sortNamed: #A).
	pattern := self signature
		nonZeroArgTermNamed: #aOneArgOp asLbOperatorName
		withArgs:
			{(self signature
				zeroArgTermNamed: #X asLbOperatorName
				extraVariables: extraVariables)}.
	trueTerm := self signature zeroArgTermNamed: #true asLbOperatorName.
	replacement := self signature
		zeroArgTermNamed: #aZeroArgOp asLbOperatorName.
	referenceRule := LbRewriteRule
		pattern: pattern
		localVariables: extraVariables
		condition: trueTerm
		replacement: replacement.
	parsedRule := self parseAsRule: '∀ X:A aOneArgOp(X) ⇒ aZeroArgOp | true'.
	self assert: parsedRule equals: referenceRule.
	^ parsedRule
]

{ #category : 'example' }
LbRuleParserExamples >> signature [
	<gtExample>
	^ LbTermParserExamples new signature
]
