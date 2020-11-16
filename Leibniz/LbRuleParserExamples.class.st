Class {
	#name : #LbRuleParserExamples,
	#superclass : #Object,
	#traits : 'TGtExampleAssertable',
	#classTraits : 'TGtExampleAssertable classTrait',
	#category : #'Leibniz-4-Rules'
}

{ #category : #accessing }
LbRuleParserExamples >> ruleWithVariable [
	<gtExample>
	| extraVariables pattern replacement referenceRule parsedRule signature |
	signature := LbTermParserExamples new signature.
	extraVariables := Dictionary with: #X asLbOperatorName-> (signature sortGraph sortNamed: #A).
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

{ #category : #accessing }
LbRuleParserExamples >> ruleWithVariableAndCondition [
	<gtExample>
	| extraVariables pattern replacement referenceRule parsedRule signature trueTerm |
	signature := LbTermParserExamples new signature.
	extraVariables := Dictionary with: #X asLbOperatorName-> (signature sortGraph sortNamed: #A).
	pattern := signature
				nonZeroArgTermNamed: #aOneArgOp asLbOperatorName
				withArgs: { signature
								zeroArgTermNamed: #X asLbOperatorName
								extraVariables: extraVariables }.
	trueTerm := signature zeroArgTermNamed: #true asLbOperatorName.
	replacement := signature zeroArgTermNamed: #aZeroArgOp asLbOperatorName.
	referenceRule := LbRewriteRule pattern: pattern localVariables: extraVariables condition: trueTerm replacement: replacement.
	parsedRule := (LbRuleParser forSignature: signature)
						parse: '∀ X:A aOneArgOp(X) ⇒ aZeroArgOp | true'.
	self assert: parsedRule equals: referenceRule.
	^ parsedRule
]
