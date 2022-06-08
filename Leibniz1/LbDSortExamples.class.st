Class {
	#name : #LbDSortExamples,
	#superclass : #Object,
	#traits : 'TGtExampleAssertable',
	#classTraits : 'TGtExampleAssertable classTrait',
	#category : 'Leibniz-7-DependentSorts'
}

{ #category : #example }
LbDSortExamples >> bagAndListTerms [
	<gtExample>
	^ #('∅' '∅ ** anElement' '∅ ++ anElement'
		'size(∅)' 'size(∅ ** anElement)' 'size(∅ ++ anElement)') collect: [ :each |
		self bagSignature parseTerm: each ]
]

{ #category : #example }
LbDSortExamples >> bagSignature [
	<gtExample>
	| sortGraph |
	sortGraph :=
		(self bagSortGraph
 union: (LbBuiltinDSortGraphs integerSortGraph
			union: LbBuiltinDSortGraphs truthSortGraph)).
	^ (LbDSignatureBuilder sortGraph: sortGraph)
		addSignature: LbBuiltinDSignatures integerSignature includeVars: false;
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
LbDSortExamples >> bagSortContext [
	<gtExample>
	| context |
	context := (LbContextBuilder name: 'sorts')
		include: (self listSortContext) mode: #use;
		parseAndAddOp: 'collection : sort';
		parseAndAddOp: 'bag(sort, ℕ) : sort';
		parseAndAddOp: 'ℕ : sort';
		parseAndAddAxiom: '∀ s:sort ∀ n:ℕ list(s, n) ⊆ bag(s, n)';
		parseAndAddAxiom: '∀ s:sort ∀ n:ℕ bag(s, n) ⊆ collection';
		parseAndAddAxiom: '∅ ⊆ collection';
		context.
	self
		assert: (context axioms subsortAxioms
					reject: #isTotal) size
		equals: 0.
	^ context
]

{ #category : #example }
LbDSortExamples >> bagSortGraph [
	<gtExample>
	^ (LbDSortGraphBuilder fromSortContext: self bagSortContext)
		sortGraph
]

{ #category : #example }
LbDSortExamples >> bagSortPairs [
	<gtExample>
	| sortGraph sorts |
	sortGraph := self bagSortGraph.
	sorts := #('bag(element.special, 2)'
				'list(element, 2)'
				'list(element.special, 2)'
				'∀ n:ℕ list(element, n)'
				'∀ n:ℕ.nz list(element, n)')
				collect: [ :each |
					sortGraph parseSort: each ].
	^ {
		(sorts at: 1) pairWith: (sorts at: 2).
		(sorts at: 4) pairWith: (sorts at: 5).
	}
]

{ #category : #example }
LbDSortExamples >> bagSorts [
	<gtExample>
	| sortGraph sorts |
	sortGraph := self bagSortGraph.
	sorts := #( "1" 'collection'
				"2" '∅'
				"3" 'bag(element, 2)'
				"4" 'list(element, 2)'
				"5" 'list(element.special, 2)'
				"6" 'bag(element, 3)'
				"7" '∀ n:ℕ bag(element, n)'
				"8" '∀ m:ℕ bag(element, m)')
				collect: [ :each |
					sortGraph parseSort: each ].
	"All these sorts are subsorts of 'collection'"
	self assert: (sorts at: 1) <= (sorts at: 1).
	self assert: (sorts at: 2) <= (sorts at: 1).
	self assert: (sorts at: 3) <= (sorts at: 1).
	self assert: (sorts at: 4) <= (sorts at: 1).
	self assert: (sorts at: 5) <= (sorts at: 1).
	self assert: (sorts at: 6) <= (sorts at: 1).
	self assert: (sorts at: 7) <= (sorts at: 1).
	self assert: (sorts at: 8) <= (sorts at: 1).
	"Direct and transitive subsort declarations"
	self assert: (sorts at: 4) <= (sorts at: 3).
	self assert: (sorts at: 5) <= (sorts at: 4).
	self assert: (sorts at: 5) <= (sorts at: 3).
	"Length mismatch"
	self assert: ((sorts at: 4) <= (sorts at: 6)) not.
	self assert: ((sorts at: 5) <= (sorts at: 6)) not.
	"Specific lengths make subsorts of generic lengths"
	self assert: (sorts at: 4) <= (sorts at: 7).
	"Names of variables don't matter"
	self assert: (sorts at: 7) <= (sorts at: 8).
	self assert: (sorts at: 8) <= (sorts at: 7).

	self assert: (((sorts at: 1) subsortGraph) at: #nodes) size equals: 4.
	self assert: (((sorts at: 3) subsortGraph) at: #nodes) size equals: 4.
	self assert: (((sorts at: 4) supersortGraph) at: #nodes) size equals: 3.
	self assert: (((sorts at: 5) supersortGraph) at: #nodes) size equals: 5.
	^ sorts
]

{ #category : #example }
LbDSortExamples >> dependentSortGraphWithPlainSorts [
	<gtExample>
	^ (LbDSortGraphBuilder new)
		parseAndAdd: 'foo';
		parseAndAdd: 'bar';
		parseAndAdd: 'baz';
		parseAndAdd: 'baz ⊆ bar';
		sortGraph
]

{ #category : #example }
LbDSortExamples >> listSignature [
	<gtExample>
	^ (LbDSignatureBuilder sortGraph: self listSortGraph)
		parseAndAddOp: '∅ : ∅';
		parseAndAddOp: '∀ s:sort ∀ n:ℕ ∀ m:ℕ (list(s, n)) ++ (list(s, m)) : list(s, n + m)';
		parseAndAddOp: '∀ s:sort ∀ n:ℕ (list(s, n)) ++ s : list(s, n + 1)';
		parseAndAddOp: '∀ s:sort ∅ ++ s : list(s, 1)';
		parseAndAddOp: 'anElement : element';
		signature
]

{ #category : #example }
LbDSortExamples >> listSortContext [
	<gtExample>
	^ (LbContextBuilder name: 'sorts')
		include: (LbBuiltinContexts integerContext) mode: #use;
		parseAndAddSort: 'sort';
		parseAndAddOp: 'element : sort';
		parseAndAddOp: 'element.special : sort';
		parseAndAddOp: '∅ : sort';
		parseAndAddOp: 'list(sort, ℕ) : sort';
		parseAndAddAxiom: 'element.special ⊆ element';
		context
]

{ #category : #example }
LbDSortExamples >> listSortGraph [
	<gtExample>
	| sortGraph |
	sortGraph := (LbDSortGraphBuilder fromSortContext: self listSortContext)
					sortGraph.
	^ sortGraph
]

{ #category : #example }
LbDSortExamples >> listTerms [
	<gtExample>
	^ {
		{'∅'. '∅'}.
		{'∅ ++ anElement'. 'list(element, 1)'}.
		{'∅ ++ anElement ++ anElement'. 'list(element, 2)'}
	  } collect: [ :each |
		| term |
		term := self listSignature parseTerm: each first.
		self assert: term sort asLeibnizSyntaxString equals: each second.
		term ]
]

{ #category : #example }
LbDSortExamples >> plainSortGraph [
	<gtExample>
	^ (LbSortGraphBuilder new)
		parseAndAdd: 'foo';
		parseAndAdd: 'bar';
		parseAndAdd: 'baz';
		parseAndAdd: 'baz ⊆ bar';
		sortGraph
]

{ #category : #example }
LbDSortExamples >> signatureWithDependentSorts [
	<gtExample>
	| sb s |
	sb := (LbDSignatureBuilder sortGraph: self sortGraphWithDependentSorts)
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
LbDSortExamples >> signatureWithoutDependentSorts [
	<gtExample>
	^ (LbDSignatureBuilder sortGraph: self sortGraphWithoutDependentSorts)
		parseAndAddOp: 'aFoo : foo';
		parseAndAddOp: 'aFoo(bar) : foo';
		parseAndAddOp: 'aBar : bar';
		parseAndAddOp: 'aBaz : baz';
		parseAndAddVar: 'aFooVar : foo';
		signature
]

{ #category : #example }
LbDSortExamples >> sortContextWithDependentSorts [
	<gtExample>
	| context |
	context := (LbContextBuilder name: 'sorts')
		include: (LbBuiltinContexts integerContext) mode: #use;
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
LbDSortExamples >> sortContextWithoutDependentSorts [
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
LbDSortExamples >> sortGraphWithDependentSorts [
	<gtExample>
	| sortGraph |
				sortGraph := (LbDSortGraphBuilder fromSortContext:
								self sortContextWithDependentSorts)								sortGraph.
	#('foo(1)' 'bar(0)' 'baz(42)') do: [ :aString |
		self
			assert: (sortGraph parseSort: aString) term sort name
			equals: #sort ].
	^ sortGraph
]

{ #category : #example }
LbDSortExamples >> sortGraphWithoutDependentSorts [
	<gtExample>
	| sortGraph |
	sortGraph := (LbDSortGraphBuilder fromSortContext:
					self sortContextWithoutDependentSorts)
					sortGraph.
	self assert: sortGraph equals: self dependentSortGraphWithPlainSorts.
	#(foo bar baz) do: [ :name |
		self
			assert: (sortGraph parseSort: name) term sort name
			equals: #sort ].
	^ sortGraph
]
