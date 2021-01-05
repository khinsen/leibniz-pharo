Class {
	#name : #LbDependentSortGraphExamples,
	#superclass : #Object,
	#traits : 'TGtExampleAssertable',
	#classTraits : 'TGtExampleAssertable classTrait',
	#category : #'Leibniz-7-DependentSorts'
}

{ #category : #example }
LbDependentSortGraphExamples >> plainSortGraph [
	<gtExample>
	^ (LbSortGraphBuilder new)
		parseAndAdd: 'foo';
		parseAndAdd: 'bar';
		parseAndAdd: 'baz';
		parseAndAdd: 'baz ⊆ bar';
		sortGraph
]

{ #category : #accessing }
LbDependentSortGraphExamples >> sortContextWithDependentSorts [
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
LbDependentSortGraphExamples >> sortContextWithoutDependentSorts [
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
LbDependentSortGraphExamples >> sortGraphWithoutDependentSorts [
	<gtExample>
	^ LbDependentSortGraph
		sortContext:self sortContextWithoutDependentSorts
]
