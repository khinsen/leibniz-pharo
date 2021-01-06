Class {
	#name : #LbDependentSortExamples,
	#superclass : #Object,
	#traits : 'TGtExampleAssertable',
	#classTraits : 'TGtExampleAssertable classTrait',
	#category : #'Leibniz-7-DependentSorts'
}

{ #category : #example }
LbDependentSortExamples >> plainSortGraph [
	<gtExample>
	^ (LbSortGraphBuilder new)
		parseAndAdd: 'foo';
		parseAndAdd: 'bar';
		parseAndAdd: 'baz';
		parseAndAdd: 'baz ⊆ bar';
		sortGraph
]

{ #category : #example }
LbDependentSortExamples >> signatureWithDependentSorts [
	<gtExample>
	^ (LbDependentSignatureBuilder sortGraph: self sortGraphWithDependentSorts)
		parseAndAddOp: 'aFoo : foo(0)';
		parseAndAddOp: '∀ n:ℕ aFoo(bar(n)) : foo(n + 1)';
		parseAndAddOp: 'aBar : bar(0)';
		parseAndAddOp: '∀ n:ℕ aBar(foo(n)) : bar(n + 1)';
		parseAndAddOp: 'aBaz : baz(0)';
		yourself
]

{ #category : #example }
LbDependentSortExamples >> signatureWithoutDependentSorts [
	<gtExample>
	^ (LbDependentSignatureBuilder sortGraph: self sortGraphWithoutDependentSorts)
		parseAndAddOp: 'aFoo : foo';
		parseAndAddOp: 'aFoo(bar) : foo';
		parseAndAddOp: 'aBar : bar';
		parseAndAddOp: 'aBaz : baz';
		yourself
]

{ #category : #example }
LbDependentSortExamples >> sortContextWithDependentSorts [
	<gtExample>
	^ (LbContextBuilder name: 'sorts')
		include: (LbBuiltinContexts integerContext) inMode: #use;
		parseAndAddSort: 'sort';
		parseAndAddOp: 'foo(ℕ) : sort';
		parseAndAddOp: 'bar(ℕ) : sort';
		parseAndAddOp: 'baz(ℕ) : sort';
		parseAndAddStatement: '∀ n:ℕ baz(n) ⊆ bar(n)';
		context
]

{ #category : #example }
LbDependentSortExamples >> sortContextWithoutDependentSorts [
	<gtExample>
	^ (LbContextBuilder name: 'sorts')
		parseAndAddSort: 'sort';
		parseAndAddOp: 'foo : sort';
		parseAndAddOp: 'bar : sort';
		parseAndAddOp: 'baz : sort';
		parseAndAddStatement: 'baz ⊆ bar';
		context
]

{ #category : #example }
LbDependentSortExamples >> sortGraphWithDependentSorts [
	<gtExample>
	| sortGraph |
	sortGraph := LbDependentSortGraph
		sortContext: self sortContextWithDependentSorts.
	#('foo(1)' 'bar(0)' 'baz(42)') do: [ :aString |
		self
			assert: (sortGraph parseSort: aString) sort name
			equals: #sort ].
	^ sortGraph
]

{ #category : #example }
LbDependentSortExamples >> sortGraphWithoutDependentSorts [
	<gtExample>
	| sortGraph |
	sortGraph := LbDependentSortGraph
		sortContext:self sortContextWithoutDependentSorts.
	#(foo bar baz) do: [ :name |
		self
			assert: (sortGraph parseSort: name) sort name
			equals: #sort ].
	^ sortGraph
]