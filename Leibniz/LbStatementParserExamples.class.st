Class {
	#name : #LbStatementParserExamples,
	#superclass : #Object,
	#traits : 'TGtExampleAssertable',
	#classTraits : 'TGtExampleAssertable classTrait',
	#category : #'Leibniz-5-Statements'
}

{ #category : #example }
LbStatementParserExamples >> equationWithVariable [
	<gtExample>
	| extraVariables left right referenceEquation parsedEquation |
	extraVariables := Dictionary with: #X asLbOperatorName-> (self termSignature sortNamed: #A).
	left := self termSignature parseTerm: 'aOneArgOp(X)' extraVariables: extraVariables.
	right := self termSignature parseTerm: 'aZeroArgOp'.
	referenceEquation := LbEquation left: left right: right localVariables: extraVariables.
	parsedEquation := self statementParserForTermSignature
						parse: '∀ X:A aOneArgOp(X) = aZeroArgOp'.
	self assert: parsedEquation equals: referenceEquation.
	^ parsedEquation
]

{ #category : #accessing }
LbStatementParserExamples >> equationWithVariableAndCondition [
	<gtExample>
	| extraVariables left right referenceEquation parsedEquation trueTerm |
	extraVariables := Dictionary
		with: #X asLbOperatorName -> (self termSignature sortNamed: #A).
	left := self termSignature
		nonZeroArgTermNamed: #aOneArgOp asLbOperatorName
		withArgs:
			{(self termSignature
				zeroArgTermNamed: #X asLbOperatorName
				extraVariables: extraVariables)}.
	trueTerm := self termSignature zeroArgTermNamed: #true asLbOperatorName.
	right := self termSignature
		zeroArgTermNamed: #aZeroArgOp asLbOperatorName.
	referenceEquation :=
		LbEquation
			left: left
			right: right
			localVariables: extraVariables
			condition: trueTerm.
	parsedEquation := self statementParserForTermSignature
		parse: '∀ X:A aOneArgOp(X) = aZeroArgOp | true'.
	self assert: parsedEquation equals: referenceEquation.
	^ parsedEquation
]

{ #category : #example }
LbStatementParserExamples >> noVarEquation [
	<gtExample>
	| left right expected equation |
	equation := self noVarStatementParser parse: 'aOneArgOp(aZeroArgOp) = aZeroArgOp'.
	left := self termSignature parseTerm: 'aOneArgOp(aZeroArgOp)'.
	right := self termSignature parseTerm: 'aZeroArgOp'.
	expected := LbEquation left: left right: right.
	self assert: equation equals: expected.
	^ equation
]

{ #category : #example }
LbStatementParserExamples >> noVarStatementParser [
	<gtExample>
	^ LbNoVarStatementParser
		signature: self termSignature
		extraVariables: Dictionary new
]

{ #category : #example }
LbStatementParserExamples >> noVarSubsort [
	<gtExample>
	| sub superSort expected relation |
	relation := self noVarSubsortParser parse: 'foo ⊆ bar'.
	sub := self sortTermParser parse: 'foo'.
	superSort := self sortTermParser parse: 'bar'.
	expected := LbSubsortStatement subsort: sub supersort: superSort.
	self assert: relation equals: expected.

	^ relation
]

{ #category : #example }
LbStatementParserExamples >> noVarSubsortParser [
	<gtExample>
	^ LbNoVarStatementParser
		signature: self sortSignature
		extraVariables: Dictionary new
]

{ #category : #example }
LbStatementParserExamples >> sortSignature [
	<gtExample>
	^ (LbSignatureBuilder sortGraph: self sortSortGraph)
		parseAndAddOp: 'foo : sort';
		parseAndAddOp: 'bar : sort';
		parseAndAddOp: 'foo(sort) : sort';
		parseAndAddOp: 'bar(sort) : sort';
		signature
]

{ #category : #accessing }
LbStatementParserExamples >> sortSortGraph [
	<gtExample>
	^ LbSortGraphBuilder new
		parseAndAdd: 'sort';
		sortGraph
]

{ #category : #accessing }
LbStatementParserExamples >> sortTermParser [
	<gtExample>
	^ LbTermParser signature: self sortSignature
]

{ #category : #example }
LbStatementParserExamples >> statementParserForSortSignature [
	<gtExample>
	^ LbStatementParser signature: self sortSignature
]

{ #category : #example }
LbStatementParserExamples >> statementParserForTermSignature [
	<gtExample>
	^ LbStatementParser signature: self termSignature
]

{ #category : #accessing }
LbStatementParserExamples >> subsortWithVariable [
	<gtExample>
	| extraVariables subSort superSort expected relation |
	extraVariables := Dictionary with: #S asLbOperatorName-> (self sortSignature sortNamed: #sort).
	subSort := self sortSignature parseTerm: 'foo(S)' extraVariables: extraVariables.
	superSort := self sortSignature parseTerm: 'bar(S)' extraVariables: extraVariables.
	relation := self statementParserForSortSignature parse: '∀ S:sort foo(S) ⊆ bar(S)'.
	expected := LbSubsortStatement subsort: subSort supersort: superSort localVariables: extraVariables.
	self assert: relation equals: expected.
	^ relation
]

{ #category : #example }
LbStatementParserExamples >> termSignature [
	<gtExample>
	^ LbTermParserExamples new signature
]
