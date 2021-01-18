Class {
	#name : #LbAxiomExamples,
	#superclass : #Object,
	#traits : 'TGtExampleAssertable',
	#classTraits : 'TGtExampleAssertable classTrait',
	#category : #'Leibniz-5-Axioms'
}

{ #category : #example }
LbAxiomExamples >> equalityAxioms [
	<gtExample>
	^ (LbAxiomBuilder signature: LbBuiltinSignatures integerSignature)
		parseAndAdd: '∀ X:zero abs(X) = 0';
		parseAndAdd: '∀ X:ℤ abs(X) = 0 | X == 0';
		parseAndAdd: '2 + 2 = 4';
		parseAndAdd: '2 < 3 = true';
		axioms
]

{ #category : #example }
LbAxiomExamples >> mixedAxioms [
	<gtExample>
	^ (LbAxiomBuilder signature: self sortSignature)
		parseAndAdd: 'foo ⊆ bar';
		parseAndAdd: '∀ S:sort foo(S) ⊆ bar(S)';
		parseAndAdd: '∀ S:sort foo(S) = bar(S)';
		parseAndAdd: 'foo = bar';
		axioms
]

{ #category : #example }
LbAxiomExamples >> sortSignature [
	<gtExample>
	^ (LbSignatureBuilder sortGraph: self sortSortGraph)
		parseAndAddOp: 'foo : sort';
		parseAndAddOp: 'bar : sort';
		parseAndAddOp: 'foo(sort) : sort';
		parseAndAddOp: 'bar(sort) : sort';
		parseAndAddOp: 'foo(sort, sort) : sort';
		parseAndAddOp: 'bar(sort, sort) : sort';
		signature
]

{ #category : #example }
LbAxiomExamples >> sortSortGraph [
	<gtExample>
	^ LbSortGraphBuilder new
		parseAndAdd: 'sort';
		sortGraph
]

{ #category : #example }
LbAxiomExamples >> subsortAxioms [
	<gtExample>
	| axioms |
	axioms := (LbAxiomBuilder signature: self sortSignature)
		parseAndAdd: 'foo ⊆ bar';
		parseAndAdd: '∀ S:sort foo(S) ⊆ bar(S)';
		parseAndAdd: '∀ S:sort foo(S, S) ⊆ bar(S, S)';
		axioms.
	self
		assert: (axioms subsortAxioms select: #isTotal) size
		equals: 2.
	^ axioms
]
