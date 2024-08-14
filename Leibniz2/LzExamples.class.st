Class {
	#name : #LzExamples,
	#superclass : #Object,
	#traits : 'TGtExampleAssertable',
	#classTraits : 'TGtExampleAssertable classTrait',
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #example }
LzExamples >> bagContext [
	<gtExample>
	^ LzContextBuilder new
		include: self listContext;
		include: (LzBook contextNamed: 'Integers');
		sort: 'collection';
		sort: 'bag(𝕊, ℕ)';
		subsort: 's_:𝕊, n_:ℕ, list(s_, n_) ⊆ bag(s_, n_)';
		subsort: 's_:𝕊, n_:ℕ, bag(s_, n_) ⊆ collection';
		subsort: '∅ ⊆ collection';
		op: 's_:𝕊, n_:ℕ, m_:ℕ, (bag(s_, n_)) ** (bag(s_, m_)) : bag(s_, n_ + m_)';
		op: 's_:𝕊, n_:ℕ, (bag(s_, n_)) ** s_ : bag(s_, n_ + 1)';
		op: 's_:𝕊, ∅ ** s_ : bag(s_, 1)';
		op: 'size(collection) : ℕ';
		context
]

{ #category : #example }
LzExamples >> bagRules [
	<gtExample>
	| context |
	context := self bagContext.
	^ {
		'∅ ++ 1 ⇒ ∅'.
		'size(∅) ⇒ 0'.
	} collect: [ :each |
		| rule |
		rule := context rule: each.
		self assert: rule asLeibnizSyntaxString equals: each.
		rule ]
]

{ #category : #example }
LzExamples >> bagSignature [
	<gtExample>
	^ LzSignatureBuilder new
		sortGraph: self bagSortGraph;
		include: self listSignature;
		op: 's_:𝕊, n_:ℕ, m_:ℕ, (bag(s_, n_)) ** (bag(s_, m_)) : bag(s_, n_ + m_)';
		op: 's_:𝕊, n_:ℕ, (bag(s_, n_)) ** s_ : bag(s_, n_ + 1)';
		op: 's_:𝕊, ∅ ** s_ : bag(s_, 1)';
		signature

]

{ #category : #example }
LzExamples >> bagSortContext [
	<gtExample>
	^ LzContextBuilder new
		include: self listSortContext;
		op: 'collection : 𝕊';
		op: 'bag(𝕊, ℕ) : 𝕊';
		op: 'ℕ : 𝕊';
		axiom: 's_:𝕊, n_:ℕ, list(s_, n_) ⊆ bag(s_, n_)';
		axiom: 's_:𝕊, n_:ℕ, bag(s_, n_) ⊆ collection';
		axiom: '∅ ⊆ collection';
		context
]

{ #category : #example }
LzExamples >> bagSortGraph [
	<gtExample>
	^ LzSortGraphBuilder new
		sortContext: self bagSortContext;
		sortGraph
]

{ #category : #example }
LzExamples >> listContext [
	<gtExample>
	^ LzContextBuilder new
		includeSortContext: (LzBook contextNamed: 'Integers');
		sort: 'element';
		sort: 'element.special';
		sort: '∅';
		sort: 'list(𝕊, ℕ)';
		subsort: 'element.special ⊆ element';		
		op: '∅ : ∅';
		op: 's_:𝕊, n_:ℕ, m_:ℕ, ',
				'(list(s_, n_)) ++ (list(s_, m_)) : list(s_, n_ + m_)';
		op: 's_:𝕊, n_:ℕ, ',
				'(list(s_, n_)) ++ s_ : list(s_, n_ + 1)';
		op: 's_:𝕊, ',
				'∅ ++ s_ : list(s_, 1)';
		op: 's_:𝕊, n_:ℕ.nz, ',
				'first(list(s_, n_)) : s_';
		op: 'anElement : element';
		op: 'aSpecialElement : element.special';
		rule: 's__:𝕊, e_:s__, first(∅ ++ e_) ⇒ e_';
		context

]

{ #category : #example }
LzExamples >> listOfIntegerTerms [
	<gtExample>
	| context |
	context := self listPlusIntegerContext.
	^ {
		'∅'.
		'∅ ++ 1'.
		'∅ ++ 1 ++ 2'.
		'first(∅ ++ 1)'.
	}
	collect: [ :each |
		 context term: each ]
]

{ #category : #example }
LzExamples >> listPlusIntegerContext [
	<gtExample>
	^ LzContextBuilder new
		include: self listContext;
		include: (LzBook contextNamed: 'Integers');
		include: (LzBook contextNamed: 'Term equality');
		context
]

{ #category : #example }
LzExamples >> listSignature [
	<gtExample>
	^ LzSignatureBuilder new
		sortGraph: self listSortGraph;
		op: '∅ : ∅';
		op: 's_:𝕊, n_:ℕ, m_:ℕ, ',
				'(list(s_, n_)) ++ (list(s_, m_)) : list(s_, n_ + m_)';
		op: 's_:𝕊, n_:ℕ, ',
				'(list(s_, n_)) ++ s_ : list(s_, n_ + 1)';
		op: 's_:𝕊, ',
				'∅ ++ s_ : list(s_, 1)';
		op: 'anElement : element';
		signature
]

{ #category : #example }
LzExamples >> listSortContext [
	<gtExample>
	^ (LzContextBuilder new
		include: LzSortHierarchyRoot uniqueInstance sortContext;
		include: (LzBook contextNamed: 'Integers');
		op: 'element : 𝕊';
		op: 'element.special : 𝕊';
		op: '∅ : 𝕊';
		op: 'list(𝕊, ℕ) : 𝕊';
		axiom: 'element.special ⊆ element')
		context.
]

{ #category : #example }
LzExamples >> listSortGraph [
	<gtExample>
	^ LzSortGraphBuilder new
		sortContext: self listSortContext;
		sortGraph
]

{ #category : #example }
LzExamples >> listTermRewrites [
	<gtExample>
	| context |
	context := self listPlusIntegerContext.
	^ {
		'first(∅ ++ 1)'.
	}
	collect: [ :each |
		| term rewrittenTerm |
		term := context term: each.
		rewrittenTerm := context reduce: term.
		{ term. rewrittenTerm } ]
]

{ #category : #example }
LzExamples >> listTerms [
	<gtExample>
	| context |
	context := self listContext.
	^ {
		{ '∅'. '∅' }.
		{ '∅ ++ anElement'. 'list(element, 1)' }.
		{ '∅ ++ aSpecialElement'. 'list(element.special, 1)' }.
		{ '∅ ++ anElement ++ aSpecialElement'. 'list(element, 2)' }.
		{ '∅ ++ aSpecialElement ++ anElement'. 'list(element, 2)' }.
		{ 'first(∅ ++ anElement)'. 'element' }.
		{ 'first(∅ ++ aSpecialElement)'. 'element.special'}.
	}
	collect: [ :each |
		| term sort |
		 term := context term: each first.
		 sort := context sort: each second.
		 self assert: term sort equals: sort.
		 term ]
]

{ #category : #accessing }
LzExamples >> signatureWithSubsorts [
	<gtExample>
	^ LzSignatureBuilder new
		sortGraph: self sortGraphWithSubsorts;
		op: 'anA : A';
		op: 'aB : B';
		op: 'aC : C';
		op: 'aD : D';
		op: 'foo(A) : A';
		signature
]

{ #category : #example }
LzExamples >> simpleContext [
	<gtExample>
	^ self simpleContextBuilder context
]

{ #category : #example }
LzExamples >> simpleContextBuilder [
	<gtExample>
	^ LzContextBuilder new
		sort: 'Foo';
		op: 'aFoo : Foo';
		op: 'aFoo(Foo) : Foo';
		op: 'Foo + Foo : Foo';
		op: 'Foo[Foo] : Foo';
		op: 'Foo^(Foo) : Foo';
		op: 'Foo\(Foo) : Foo'.
]

{ #category : #example }
LzExamples >> simpleContextRules [
	<gtExample>
	^ {
		'aFoo ⇒ aFoo'.
		'aFoo(aFoo) ⇒ aFoo'.
		'someFoo_:Foo, aFoo(someFoo_) ⇒ someFoo_'.
	} collect: [ :each |
		| rule |
		rule := self simpleContext rule: each.
		self assert: rule asLeibnizSyntaxString equals: each.
		rule ]
]

{ #category : #example }
LzExamples >> simpleContextTermMatches [
	<gtExample>
	| context |
	context := self simpleContext.
	^ {
		{ 'foo_:Foo, foo_'. 'aFoo'.  {'foo_' -> 'aFoo'} }.
		{ 'foo_:Foo, foo_'. 'aFoo(aFoo)'.  {'foo_' -> 'aFoo(aFoo)'} }.
		{ 'foo_:Foo, aFoo(foo_)'. 'aFoo(aFoo)'. {'foo_' -> 'aFoo'} }.
		{ 'foo_:Foo, (foo_ + foo_)'. 'aFoo + aFoo'. {'foo_' -> 'aFoo'} }.
		{ 'foo_:Foo, aFoo(foo_)'. 'aFoo'. {} }
	} collect: [ :each |
		| pattern term bindings result |
		pattern := context pattern: each first.
		term := context term: each second.
		bindings := pattern match: term.
		result := each third collect: [ :eachEntry |
					(LzVarName for: eachEntry key)
						-> (context term: eachEntry value) ].
		self assert: bindings bindings equals: result asDictionary.
		bindings ]
]

{ #category : #example }
LzExamples >> simpleContextTerms [
	<gtExample>
	^ {
		'aFoo'.
		'aFoo(aFoo)'.
		'aFoo(aFoo + aFoo)'.
		'aFoo[aFoo]'.
		'aFoo^(aFoo)'.
		'aFoo\(aFoo)'
	} collect: [ :each |
		| term |
		term := self simpleContext term: each.
		self assert: term asLeibnizSyntaxString equals: each.
		term ]
]

{ #category : #example }
LzExamples >> sortGraphWithSubsorts [
	<gtExample>
	| sortGraph |
	sortGraph := (LzSortGraphBuilder new
		sort: 'A';
		sort: 'B';
		sort: 'C';
		sort: 'D';
		subsort: 'B ⊆ A';
		subsort: 'C ⊆ A';
		subsort: 'D ⊆ B';
		subsort: 'D ⊆ C')
		sortGraph.
	self assert: (sortGraph sort: 'B') <= (sortGraph sort: 'A').
	self assert: (sortGraph sort: 'C') <= (sortGraph sort: 'A').
	self assert: (sortGraph sort: 'D') <= (sortGraph sort: 'A').
	self assert: ((sortGraph sort: 'A') <= (sortGraph sort: 'B')) not.
	self assert: ((sortGraph sort: 'B') <= (sortGraph sort: 'C')) not.
	self assert: ((sortGraph sort: 'C') <= (sortGraph sort: 'B')) not.
	^ sortGraph
]

{ #category : #example }
LzExamples >> termsForSignatureWithSubsorts [
	<gtExample>
	^ {
		'anA'. 'aB'. 'aC'. 'aD'.
		'foo(anA)'. 'foo(aB)'. 'foo(aC)'. 'foo(aD)'.
	} collect: [ :each |
		self signatureWithSubsorts term: each ]
]
