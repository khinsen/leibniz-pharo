Class {
	#name : #LbStatementExamples,
	#superclass : #Object,
	#traits : 'TGtExampleAssertable',
	#classTraits : 'TGtExampleAssertable classTrait',
	#category : #'Leibniz-5-Statements'
}

{ #category : #example }
LbStatementExamples >> equations [
	<gtExample>
	^ (LbStatementsBuilder signature: LbBuiltinSignatures integerSignature)
		parseAndAdd: '∀ X:zero abs(X) = 0';
		parseAndAdd: '∀ X:ℤ abs(X) = 0 | X == 0';
		parseAndAdd: '2 + 2 = 4';
		parseAndAdd: '2 < 3 = true';
		statements
]

{ #category : #example }
LbStatementExamples >> mixedStatements [
	<gtExample>
	^ (LbStatementsBuilder signature: self sortSignature)
		parseAndAdd: 'foo ⊆ bar';
		parseAndAdd: '∀ S:sort foo(S) ⊆ bar(S)';
		parseAndAdd: '∀ S:sort foo(S) = bar(S)';
		parseAndAdd: 'foo = bar';
		statements
]

{ #category : #example }
LbStatementExamples >> sortSignature [
	<gtExample>
	^ (LbSignatureBuilder sortGraph: self sortSortGraph)
		parseAndAddOp: 'foo : sort';
		parseAndAddOp: 'bar : sort';
		parseAndAddOp: 'foo(sort) : sort';
		parseAndAddOp: 'bar(sort) : sort';
		signature
]

{ #category : #example }
LbStatementExamples >> sortSortGraph [
	<gtExample>
	^ LbSortGraphBuilder new
		parseAndAdd: 'sort';
		sortGraph
]

{ #category : #example }
LbStatementExamples >> subsortStatements [
	<gtExample>
	^ (LbStatementsBuilder signature: self sortSignature)
		parseAndAdd: 'foo ⊆ bar';
		parseAndAdd: '∀ S:sort foo(S) ⊆ bar(S)';
		statements
]
