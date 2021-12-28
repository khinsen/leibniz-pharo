Class {
	#name : #LbAxiomParserExamples,
	#superclass : #Object,
	#traits : 'TGtExampleAssertable',
	#classTraits : 'TGtExampleAssertable classTrait',
	#category : 'Leibniz-5-Axioms'
}

{ #category : #example }
LbAxiomParserExamples >> axiomParser [
	<gtExample>
	^ LbParser newStartingAt: #axiom
]

{ #category : #example }
LbAxiomParserExamples >> equalityWithVariable [
	<gtExample>
	| extraVariables left right referenceEquation parsedEquation |
	extraVariables := Dictionary with: #X asLbOperatorName-> (self termSignature sortNamed: #A).
	left := self termSignature parseTerm: 'aOneArgOp(X)' extraVariables: extraVariables.
	right := self termSignature parseTerm: 'aZeroArgOp'.
	referenceEquation := LbEqualityAxiom left: left right: right localVariables: extraVariables.
	parsedEquation := self parseForTermSignature: '∀ X:A aOneArgOp(X) = aZeroArgOp'.
	self assert: parsedEquation equals: referenceEquation.
	^ parsedEquation
]

{ #category : #example }
LbAxiomParserExamples >> equalityWithVariableAndCondition [
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
		LbEqualityAxiom
			left: left
			right: right
			localVariables: extraVariables
			condition: trueTerm.
	parsedEquation := self parseForTermSignature: '∀ X:A aOneArgOp(X) = aZeroArgOp | true'.
	self assert: parsedEquation equals: referenceEquation.
	^ parsedEquation
]

{ #category : #example }
LbAxiomParserExamples >> noVarEquality [
	<gtExample>
	| left right expected equation |
	equation := self parseForTermSignature: 'aOneArgOp(aZeroArgOp) = aZeroArgOp'.
	left := self termSignature parseTerm: 'aOneArgOp(aZeroArgOp)'.
	right := self termSignature parseTerm: 'aZeroArgOp'.
	expected := LbEqualityAxiom left: left right: right.
	self assert: equation equals: expected.
	^ equation
]

{ #category : #example }
LbAxiomParserExamples >> noVarSubsort [
	<gtExample>
	| sub superSort expected relation |
	relation := self parseForSortSignature: 'foo ⊆ bar'.
	sub := self parseTermForSortSignature: 'foo'.
	superSort := self parseTermForSortSignature: 'bar'.
	expected := LbSubsortAxiom subsort: sub supersort: superSort.
	self assert: relation equals: expected.

	^ relation
]

{ #category : #parsing }
LbAxiomParserExamples >> parseForSortSignature: aString [
	^ (self axiomParser parse: aString)
		cull: self sortSignature
]

{ #category : #parsing }
LbAxiomParserExamples >> parseForTermSignature: aString [
	^ (self axiomParser parse: aString)
		cull: self termSignature
]

{ #category : #parsing }
LbAxiomParserExamples >> parseTermForSortSignature: aString [
	^ (self termParser parse: aString)
		cull: self sortSignature cull: Dictionary new
]

{ #category : #example }
LbAxiomParserExamples >> sortSignature [
	<gtExample>
	^ (LbSignatureBuilder sortGraph: self sortSortGraph)
		parseAndAddOp: 'foo : sort';
		parseAndAddOp: 'bar : sort';
		parseAndAddOp: 'foo(sort) : sort';
		parseAndAddOp: 'bar(sort) : sort';
		signature
]

{ #category : #example }
LbAxiomParserExamples >> sortSortGraph [
	<gtExample>
	^ LbSortGraphBuilder new
		parseAndAdd: 'sort';
		sortGraph
]

{ #category : #example }
LbAxiomParserExamples >> subsortWithVariable [
	<gtExample>
	| extraVariables subSort superSort expected relation |
	extraVariables := Dictionary with: #S asLbOperatorName-> (self sortSignature sortNamed: #sort).
	subSort := self sortSignature parseTerm: 'foo(S)' extraVariables: extraVariables.
	superSort := self sortSignature parseTerm: 'bar(S)' extraVariables: extraVariables.
	relation := self parseForSortSignature: '∀ S:sort foo(S) ⊆ bar(S)'.
	expected := LbSubsortAxiom subsort: subSort supersort: superSort localVariables: extraVariables.
	self assert: relation equals: expected.
	^ relation
]

{ #category : #example }
LbAxiomParserExamples >> termParser [
	<gtExample>
	^ LbParser newStartingAt: #term
]

{ #category : #example }
LbAxiomParserExamples >> termSignature [
	<gtExample>
	^ LbTermParserExamples new signature
]
