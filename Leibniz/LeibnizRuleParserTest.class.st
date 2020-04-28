Class {
	#name : #LeibnizRuleParserTest,
	#superclass : #TestCase,
	#instVars : [
		'signature'
	],
	#category : #'Leibniz-Tests'
}

{ #category : #running }
LeibnizRuleParserTest >> setUp [
	| b sg |
	super setUp.

	b := LeibnizSortGraphBuilder new.
	b add: #A;
	  add: #B;
	  make: #B subsortOf: #A.
	b add: #boolean.
	sg := b sortGraph.

	b := LeibnizSignatureBuilder sortGraph: sg.
	b addBuiltin: #integers.
	b addBuiltin: #rationalNumbers.
	b addBuiltin: #fpNumbers.
	b addBuiltin: #strings.
	b addVar: #aVar ofSort: #A.
	b addOp: #aZeroArgOp ofSort: #B.
	b addOp: #aOneArgOp withArgs: #(#A) ofSort: #A.
	b addOp: #aOneArgOp withArgs: #(#B) ofSort: #B.
	b addOp: #aTwoArgOp withArgs: #(#A #A) ofSort: #A.
	b addOp: #'[]' withArgs: #(#A #A) ofSort: #A.
	b addOp: #'[]' withArgs: #(#A #A #A) ofSort: #A.
	b addOp: #'^' withArgs: #(#A #A) ofSort: #A.
	b addOp: #'^' withArgs: #(#A #A #A) ofSort: #A.
	b addOp: #'_' withArgs: #(#A #A) ofSort: #A.
	b addOp: #'_' withArgs: #(#A #A #A) ofSort: #A.
	b addOp: #'_infixOp1' withArgs: #(#A #A) ofSort: #A.
	b addOp: #'_infixOp2' withArgs: #(#A #A) ofSort: #A.
	b addOp: #true ofSort: #boolean.
	b addOp: #false ofSort: #boolean.

	signature := b signature
]

{ #category : #tests }
LeibnizRuleParserTest >> testRuleWithVariable [
	| extraVariables pattern replacement referenceRule parsedRule |
	extraVariables := Dictionary with: #X -> #A.
	pattern := signature nonZeroArgTermNamed: #aOneArgOp
							   withArgs: { signature zeroArgTermNamed: #X extraVariables: extraVariables }.
	replacement := signature zeroArgTermNamed: #aZeroArgOp.
	referenceRule := LeibnizRule pattern: pattern replacement: replacement.
	parsedRule := (LeibnizRuleParser forSignature: signature)
						parse: '∀ X:A aOneArgOp(X) ⇒ aZeroArgOp'.
	self assert: parsedRule equals: referenceRule.

]

{ #category : #tests }
LeibnizRuleParserTest >> testRuleWithVariableAndCondition [
	| extraVariables pattern trueTerm replacement referenceRule parsedRule |
	extraVariables := Dictionary with: #X -> #A.
	pattern := signature nonZeroArgTermNamed: #aOneArgOp
							   withArgs: { signature zeroArgTermNamed: #X extraVariables: extraVariables }.
	trueTerm := signature zeroArgTermNamed: #true.
	replacement := signature zeroArgTermNamed: #aZeroArgOp.
	referenceRule := LeibnizRule pattern: pattern condition: trueTerm replacement: replacement.
	parsedRule := (LeibnizRuleParser forSignature: signature)
						parse: '∀ X:A aOneArgOp(X) ⇒ aZeroArgOp | true'.
	self assert: parsedRule equals: referenceRule.

]
