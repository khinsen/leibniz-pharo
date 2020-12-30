Class {
	#name : #LbStatementParserExamples,
	#superclass : #Object,
	#traits : 'TGtExampleAssertable',
	#classTraits : 'TGtExampleAssertable classTrait',
	#category : #'Leibniz-5-Statements'
}

{ #category : #accessing }
LbStatementParserExamples >> equationWithVariable [
	<gtExample>
	| extraVariables left right referenceEquation parsedEquation |
	extraVariables := Dictionary with: #X asLbOperatorName-> (self signature sortNamed: #A).
	left := self signature
				nonZeroArgTermNamed: #aOneArgOp asLbOperatorName
				withArgs: { self signature
								zeroArgTermNamed: #X asLbOperatorName
								extraVariables: extraVariables }.
	right := self signature zeroArgTermNamed: #aZeroArgOp asLbOperatorName.
	referenceEquation := LbEquation left: left right: right localVariables: extraVariables.
	parsedEquation := self statementParser
						parse: '∀ X:A aOneArgOp(X) = aZeroArgOp'.
	self assert: parsedEquation equals: referenceEquation.
	^ parsedEquation
]

{ #category : #accessing }
LbStatementParserExamples >> equationWithVariableAndCondition [
	<gtExample>
	| extraVariables left right referenceEquation parsedEquation trueTerm |
	extraVariables := Dictionary
		with: #X asLbOperatorName -> (self signature sortNamed: #A).
	left := self signature
		nonZeroArgTermNamed: #aOneArgOp asLbOperatorName
		withArgs:
			{(self signature
				zeroArgTermNamed: #X asLbOperatorName
				extraVariables: extraVariables)}.
	trueTerm := self signature zeroArgTermNamed: #true asLbOperatorName.
	right := self signature
		zeroArgTermNamed: #aZeroArgOp asLbOperatorName.
	referenceEquation :=
		LbEquation
			left: left
			right: right
			localVariables: extraVariables
			condition: trueTerm.
	parsedEquation := self statementParser
		parse: '∀ X:A aOneArgOp(X) = aZeroArgOp | true'.
	self assert: parsedEquation equals: referenceEquation.
	^ parsedEquation
]

{ #category : #example }
LbStatementParserExamples >> noVarEquation [
	<gtExample>
	| left right expected equation |
	equation := self noVarStatementParser parse: 'aOneArgOp(aZeroArgOp) = aZeroArgOp'.
	left := self termParser parse: 'aOneArgOp(aZeroArgOp)'.
	right := self termParser parse: 'aZeroArgOp'.
	expected := LbEquation left: left right: right.
	self assert: equation equals: expected.

	^ equation
]

{ #category : #example }
LbStatementParserExamples >> noVarStatementParser [
	<gtExample>
	^ LbNoVarStatementParser
		signature: LbRuleParserExamples new signature
		extraVariables: Dictionary new
]

{ #category : #example }
LbStatementParserExamples >> signature [
	<gtExample>
	^ LbTermParserExamples new signature
]

{ #category : #example }
LbStatementParserExamples >> statementParser [
	<gtExample>
	^ LbStatementParser signature: self signature
]

{ #category : #example }
LbStatementParserExamples >> termParser [
	<gtExample>
	^ LbRuleParserExamples new termParser
]
