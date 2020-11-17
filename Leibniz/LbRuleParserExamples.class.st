Class {
	#name : #LbRuleParserExamples,
	#superclass : #Object,
	#traits : 'TGtExampleAssertable',
	#classTraits : 'TGtExampleAssertable classTrait',
	#category : #'Leibniz-4-Rules'
}

{ #category : #example }
LbRuleParserExamples >> noVarRule [
	<gtExample>
	| pattern replacement expected rule1 rule2 |
	rule1 := self noVarRuleParser parse: 'aOneArgOp(aZeroArgOp) ⇒ aZeroArgOp'.
	pattern := self termParser parse: 'aOneArgOp(aZeroArgOp)'.
	replacement := self termParser parse: 'aZeroArgOp'.
	expected := LbRewriteRule pattern: pattern replacement: replacement.
	self assert: rule1 equals: expected.

	rule2 := self noVarRuleParser parse: 'aOneArgOp(aVar) → ''aVar'':LeibnizAtomicTerm'.
	pattern := self termParser parse: 'aOneArgOp(aVar)'.
	expected := LbFunctionRule pattern: pattern function: #('aVar' #LbAtomicTerm).
	self assert: rule2 equals: expected.

	^ { rule1. rule2 }
]

{ #category : #example }
LbRuleParserExamples >> noVarRuleParser [
	<gtExample>
	^ LbNoVarRuleParser forSignature: self signature extraVariables: Dictionary new
]

{ #category : #example }
LbRuleParserExamples >> noVarRuleSyntax [
	<gtExample>
	^ #(
		'aOneArgOp(aZeroArgOp) ⇒ aZeroArgOp'
		'aOneArgOp(aVar) → ''aVar'':LeibnizStringTerm'
	) collect: [ :each |
		| rule |
		rule := self noVarRuleParser parse: each.
		self assert: rule asLeibnizSyntaxString equals: each.
		rule ]
]

{ #category : #accessing }
LbRuleParserExamples >> noVarRuleWithCondition [
	<gtExample>
	| pattern replacement trueTerm rule |
	pattern := self termParser parse: 'aOneArgOp(aZeroArgOp)'.
	replacement := self termParser parse: 'aZeroArgOp'.
	trueTerm := self termParser parse: 'true'.
	rule := self noVarRuleParser parse: 'aOneArgOp(aZeroArgOp) ⇒ aZeroArgOp | true'.
	self
		assert: rule
		equals: (LbRewriteRule
					pattern: pattern
					condition: trueTerm
					replacement: replacement).
	^ rule
]

{ #category : #example }
LbRuleParserExamples >> ruleParser [
	<gtExample>
	^ LbRuleParser forSignature: self signature
]

{ #category : #example }
LbRuleParserExamples >> ruleWithVariable [
	<gtExample>
	| extraVariables pattern replacement referenceRule parsedRule signature |
	signature := LbTermParserExamples new signature.
	extraVariables := Dictionary with: #X asLbOperatorName-> (signature sortNamed: #A).
	pattern := signature
				nonZeroArgTermNamed: #aOneArgOp asLbOperatorName
				withArgs: { signature
								zeroArgTermNamed: #X asLbOperatorName
								extraVariables: extraVariables }.
	replacement := signature zeroArgTermNamed: #aZeroArgOp asLbOperatorName.
	referenceRule := LbRewriteRule pattern: pattern localVariables: extraVariables replacement: replacement.
	parsedRule := (LbRuleParser forSignature: signature)
						parse: '∀ X:A aOneArgOp(X) ⇒ aZeroArgOp'.
	self assert: parsedRule equals: referenceRule.
	^ parsedRule
]

{ #category : #example }
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
	parsedRule := self ruleParser
		parse: '∀ X:A aOneArgOp(X) ⇒ aZeroArgOp | true'.
	self assert: parsedRule equals: referenceRule.
	^ parsedRule
]

{ #category : #example }
LbRuleParserExamples >> signature [
	<gtExample>
	^ LbTermParserExamples new signature
]

{ #category : #example }
LbRuleParserExamples >> termParser [
	<gtExample>
	^ LbTermParser forSignature: self signature
]
