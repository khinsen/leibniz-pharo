Class {
	#name : #LeibnizRuleParserTest,
	#superclass : #LeibnizParserTest,
	#category : #'Leibniz-Tests'
}

{ #category : #accessing }
LeibnizRuleParserTest >> parserClass [
	^ LeibnizRuleConstructor
]

{ #category : #tests }
LeibnizRuleParserTest >> testRuleWithCondition [
	| pattern replacement trueTerm |
	pattern := parser signature nonZeroArgTermNamed: #aOneArgOp
										 withArgs: { parser signature zeroArgTermNamed: #aZeroArgOp }.
	replacement := parser signature zeroArgTermNamed: #aZeroArgOp.
	trueTerm := parser signature zeroArgTermNamed: #true.
	self parse: 'aOneArgOp(aZeroArgOp) ⇒ aZeroArgOp | true'.
	self assert: result
		  equals: (LeibnizRule pattern: pattern condition: trueTerm replacement: replacement).

]

{ #category : #tests }
LeibnizRuleParserTest >> testSimpleRule [
	| pattern replacement |
	pattern := parser signature nonZeroArgTermNamed: #aOneArgOp
										 withArgs: { parser signature zeroArgTermNamed: #aZeroArgOp }.
	replacement := parser signature zeroArgTermNamed: #aZeroArgOp.
	self parse: 'aOneArgOp(aZeroArgOp) ⇒ aZeroArgOp'.
	self assert: result
		  equals: (LeibnizRule pattern: pattern replacement: replacement).

]
