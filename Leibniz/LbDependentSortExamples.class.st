Class {
	#name : #LbDependentSortExamples,
	#superclass : #Object,
	#traits : 'TGtExampleAssertable',
	#classTraits : 'TGtExampleAssertable classTrait',
	#category : #'Leibniz-7-DependentSorts'
}

{ #category : #example }
LbDependentSortExamples >> bagAndListTerms [
	<gtExample>
	^ #('∅' '∅ ** anElement' '∅ ++ anElement'
		'size(∅)' 'size(∅ ** anElement)' 'size(∅ ++ anElement)') collect: [ :each |
		self bagSignature parseTerm: each ]
]

{ #category : #example }
LbDependentSortExamples >> bagSignature [
	<gtExample>
	^ (LbDependentSignatureBuilder sortGraph: self bagSortGraph)
		addBuiltin: #integers;
		parseAndAddOp: '∅ : ∅';
		parseAndAddOp: '∀ s:sort ∀ n:ℕ ∀ m:ℕ (list(s, n)) ++ (list(s, m)) : list(s, n + m)';
		parseAndAddOp: '∀ s:sort ∀ n:ℕ (list(s, n)) ++ s : list(s, n + 1)';
		parseAndAddOp: '∀ s:sort ∅ ++ s : list(s, 1)';
		parseAndAddOp: '∀ s:sort ∀ n:ℕ ∀ m:ℕ (bag(s, n)) ** (bag(s, m)) : bag(s, n + m)';
		parseAndAddOp: '∀ s:sort ∀ n:ℕ (bag(s, n)) ** s : bag(s, n + 1)';
		parseAndAddOp: '∀ s:sort ∅ ** s : bag(s, 1)';
		parseAndAddOp: 'anElement : element';
		parseAndAddOp: 'size(collection) : ℕ';
		signature
]

{ #category : #example }
LbDependentSortExamples >> bagSortGraph [
	<gtExample>
	| sortContext |
	sortContext := (LbContextBuilder name: 'sorts')
		include: (self listSortContext) inMode: #use;
		parseAndAddOp: 'collection : sort';
		parseAndAddOp: 'bag(sort, ℕ) : sort';
		parseAndAddOp: 'ℕ : sort';
		parseAndAddOp: 'ℕ.nz : sort';
		parseAndAddOp: 'zero : sort';
		parseAndAddAxiom: '∀ s:sort ∀ n:ℕ list(s, n) ⊆ bag(s, n)';
		parseAndAddAxiom: '∀ s:sort ∀ n:ℕ bag(s, n) ⊆ collection';
		parseAndAddAxiom: '∅ ⊆ collection';
		parseAndAddAxiom: 'zero ⊆ ℕ';
		parseAndAddAxiom: 'ℕ.nz ⊆ ℕ';
		context.
	self
		assert: (sortContext axioms subsortAxioms
					reject: #isTotal) size
		equals: 0.
	^ LbDependentSortGraph
		sortContext: sortContext
]

{ #category : #example }
LbDependentSortExamples >> listSignature [
	<gtExample>
	^ (LbDependentSignatureBuilder sortGraph: self listSortGraph)
		parseAndAddOp: '∅ : ∅';
		parseAndAddOp: '∀ s:sort ∀ n:ℕ ∀ m:ℕ (list(s, n)) ++ (list(s, m)) : list(s, n + m)';
		parseAndAddOp: '∀ s:sort ∀ n:ℕ (list(s, n)) ++ s : list(s, n + 1)';
		parseAndAddOp: '∀ s:sort ∅ ++ s : list(s, 1)';
		parseAndAddOp: 'anElement : element';
		signature
]

{ #category : #example }
LbDependentSortExamples >> listSortContext [
	<gtExample>
	^ (LbContextBuilder name: 'sorts')
		include: (LbBuiltinContexts integerContext) inMode: #use;
		parseAndAddSort: 'sort';
		parseAndAddOp: 'element : sort';
		parseAndAddOp: '∅ : sort';
		parseAndAddOp: 'list(sort, ℕ) : sort';
		context
]

{ #category : #example }
LbDependentSortExamples >> listSortGraph [
	<gtExample>
	| sortGraph |
	sortGraph := LbDependentSortGraph
		sortContext: self listSortContext.
	^ sortGraph
]

{ #category : #example }
LbDependentSortExamples >> listTerms [
	<gtExample>
	^ #('∅' '∅ ++ anElement' '∅ ++ anElement ++ anElement') collect: [ :each |
		self listSignature parseTerm: each ]
]

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
	| sb s |
	sb := (LbDependentSignatureBuilder sortGraph: self sortGraphWithDependentSorts)
		parseAndAddOp: 'aFoo : foo(0)';
		parseAndAddOp: '∀ n:ℕ aFoo(bar(n)) : foo(n + 1)';
		parseAndAddOp: 'aBar : bar(0)';
		parseAndAddOp: '∀ n:ℕ aBar(foo(n)) : bar(n + 1)';
		parseAndAddOp: 'aBaz : baz(0)';
		parseAndAddVar: '∀ n:ℕ aFooVar : foo(n)'.
	s := sb signature.
	self
		should: [ sb parseAndAddOp: '∀ n:ℕ aQuux(bar(0)) : foo(n)' ]
		raise: Error.
	^ s
]

{ #category : #example }
LbDependentSortExamples >> signatureWithoutDependentSorts [
	<gtExample>
	^ (LbDependentSignatureBuilder sortGraph: self sortGraphWithoutDependentSorts)
		parseAndAddOp: 'aFoo : foo';
		parseAndAddOp: 'aFoo(bar) : foo';
		parseAndAddOp: 'aBar : bar';
		parseAndAddOp: 'aBaz : baz';
		parseAndAddVar: 'aFooVar : foo';
		signature
]

{ #category : #example }
LbDependentSortExamples >> sortContextWithDependentSorts [
	<gtExample>
	| context |
	context := (LbContextBuilder name: 'sorts')
		include: (LbBuiltinContexts integerContext) inMode: #use;
		parseAndAddSort: 'sort';
		parseAndAddOp: 'foo(ℕ) : sort';
		parseAndAddOp: 'bar(ℕ) : sort';
		parseAndAddOp: 'baz(ℕ) : sort';
		parseAndAddAxiom: '∀ n:ℕ.nz baz(n) ⊆ bar(n)';
		context.
	self assert: context axioms subsortAxioms anyOne isTotal not.
	^ context
]

{ #category : #example }
LbDependentSortExamples >> sortContextWithoutDependentSorts [
	<gtExample>
	^ (LbContextBuilder name: 'sorts')
		parseAndAddSort: 'sort';
		parseAndAddOp: 'foo : sort';
		parseAndAddOp: 'bar : sort';
		parseAndAddOp: 'baz : sort';
		parseAndAddAxiom: 'baz ⊆ bar';
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
			assert: (sortGraph parseSort: aString) term sort name
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
			assert: (sortGraph parseSort: name) term sort name
			equals: #sort ].
	^ sortGraph
]
