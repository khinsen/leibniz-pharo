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
		include: LzBuiltinContexts integerContext;
		sort: 'collection';
		sort: 'bag(𝕊, ℕ)';
		subsort: '∀ s_:𝕊 ∀ n_:ℕ list(s_, n_) ⊆ bag(s_, n_)';
		subsort: '∀ s_:𝕊 ∀ n_:ℕ bag(s_, n_) ⊆ collection';
		subsort: '∅ ⊆ collection';
		op: '∀ s_:𝕊 ∀ n_:ℕ ∀ m_:ℕ (bag(s_, n_)) ** (bag(s_, m_)) : bag(s_, n_ + m_)';
		op: '∀ s_:𝕊 ∀ n_:ℕ (bag(s_, n_)) ** s_ : bag(s_, n_ + 1)';
		op: '∀ s_:𝕊 ∅ ** s_ : bag(s_, 1)';
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
		op: '∀ s_:𝕊 ∀ n_:ℕ ∀ m_:ℕ (bag(s_, n_)) ** (bag(s_, m_)) : bag(s_, n_ + m_)';
		op: '∀ s_:𝕊 ∀ n_:ℕ (bag(s_, n_)) ** s_ : bag(s_, n_ + 1)';
		op: '∀ s_:𝕊 ∅ ** s_ : bag(s_, 1)';
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
		axiom: '∀ s_:𝕊 ∀ n_:ℕ list(s_, n_) ⊆ bag(s_, n_)';
		axiom: '∀ s_:𝕊 ∀ n_:ℕ bag(s_, n_) ⊆ collection';
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
LzExamples >> booleanUnifications [
	<gtExample>
	| c |
	c := LzContextBuilder new
			include: LzExampleContexts booleanContext;
			var: 'X_ : 𝔹';
			var: 'Y_ : 𝔹';
			context.
	^ {
		{'⊤'. 'X_'. '(X_=⊤)'}.
		{'¬(X_)'. '¬(⊤)'. '(X_=⊤)'}.
		{'X_'. '¬(⊤)'. '(X_=¬(⊤))'}.
		{'⊤ ⊻ ⊥ ⊻ ⊤ ⊻ ¬(⊤)'. '⊤ ⊻ ⊥ ⊻ X_ ⊻ Y_'. '(X_=⊤, Y_=¬(⊤))'}.
		{'⊥ ⊻ X_ ⊻ ⊤ ⊻ ¬(⊤)'. '⊥ ⊻ ⊤ ⊻ X_ ⊻ Y_'. '(X_=⊤, Y_=¬(⊤))'}.
		{'X_ ⊻ ¬(X_)'. '⊥ ⊻ ¬(X_)'. '(X_=⊥)'}.
		{'X_ ⊻ ¬(Y_)'. '⊥ ⊻ ¬(Y_)'. '(Y_, X_=⊥)'}.
		{'⊥ ⊻ ¬(X_)'. '⊥ ⊻ ¬(Y_)'. '(X_=Y_)'}.
		{'⊤'. '⊥'.  '(failure #nonUnifiableTerms: ⊥, ⊤)' }.
		{'∀ foo_:𝔹 ¬(foo_)'. '∀ bar_:𝔹 ¬(bar_)'. '(bar_=foo_)'}
	} collect: [ :each |
		| unification string |
		unification := (c pattern: each first) unify: (c pattern: each  second).
		string := unification printString.
		self assert: (string allButFirst: (string findString: '(') - 1) equals: each third.
		unification ]
]

{ #category : #example }
LzExamples >> integerArithmetic [
	<gtExample>
	| context |
	context := LzBuiltinContexts integerContext.
	^ {
		{ '-(2)'. '-2' }.
		{ '2 + 2'. '4'}.
		{ '2 - 2'. '0'}.
		{ '3 × 2'. '6'}.
		{ '3 div 2'. '1'}.		
		{ '3 rem 2'. '1'}.
		{ '3^{2}'. '9'}.
		{ '3^{0}'. '1'}.
		{ '0^{2}'. '0'}.
		{ '2 < 3'. '⊤'}.
		{ '2 > 3'. '⊥'}.
	}
	collect: [ :each |
		| term result |
		term := context term: each first.
		result := context reduce: term.
		self assert: result equals: (context term: each second).
		{ term. result } ]
]

{ #category : #example }
LzExamples >> integerTerms [
	<gtExample>
	| context |
	context := LzBuiltinContexts integerContext.
	^ {
		{ '0'. 'zero'. }.
		{ '1'. 'ℕ.nz' }.
		{ '-1'. 'ℤ.nz' }.
		{ '-1 + 1'. 'ℤ' }.
		{ '1 + 1'. 'ℕ.nz' }.
	}
	collect: [ :each |
		| term |
		term := context term: each first.
		self assert: term sort asLeibnizSyntaxString equals: each second.
		term  ]
]

{ #category : #example }
LzExamples >> listContext [
	<gtExample>
	^ LzContextBuilder new
		includeSortContext: LzBuiltinContexts integerContext;
		includeSortContext: LzBuiltinContexts sortContext;
		include: LzBuiltinContexts sortContext;
		sort: 'element';
		sort: 'element.special';
		sort: '∅';
		sort: 'list(𝕊, ℕ)';
		subsort: 'element.special ⊆ element';		
		op: '∅ : ∅';
		op: '∀ s_:𝕊 ∀ n_:ℕ ∀ m_:ℕ ',
				'(list(s_, n_)) ++ (list(s_, m_)) : list(s_, n_ + m_)';
		op: '∀ s_:𝕊 ∀ n_:ℕ ',
				'(list(s_, n_)) ++ s_ : list(s_, n_ + 1)';
		op: '∀ s_:𝕊 ',
				'∅ ++ s_ : list(s_, 1)';
		op: 'anElement : element';
		context
]

{ #category : #example }
LzExamples >> listPlusIntegerContext [
	<gtExample>
	^ LzContextBuilder new
		include: self listContext;
		include: LzBuiltinContexts integerContext;
		context
]

{ #category : #example }
LzExamples >> listSignature [
	<gtExample>
	^ LzSignatureBuilder new
		sortGraph: self listSortGraph;
		op: '∅ : ∅';
		op: '∀ s_:𝕊 ∀ n_:ℕ ∀ m_:ℕ ',
				'(list(s_, n_)) ++ (list(s_, m_)) : list(s_, n_ + m_)';
		op: '∀ s_:𝕊 ∀ n_:ℕ ',
				'(list(s_, n_)) ++ s_ : list(s_, n_ + 1)';
		op: '∀ s_:𝕊 ',
				'∅ ++ s_ : list(s_, 1)';
		op: 'anElement : element';
		signature
]

{ #category : #example }
LzExamples >> listSortContext [
	<gtExample>
	^ (LzContextBuilder new
		include: LzBuiltinContexts sortContext;
		include: LzBuiltinContexts integerContext;
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
LzExamples >> listTerms [
	<gtExample>
	| context |
	context := self listPlusIntegerContext.
	^ {
		'∅'.
		'∅ ++ 1'.
		'∅ ++ 1 ++ 2'.
	}
	collect: [ :each |
		 context term: each ]
]

{ #category : #example }
LzExamples >> rationalArithmetic [
	<gtExample>
	| context |
	context := LzBuiltinContexts rationalNumberContext.
	^ {
		{ '-(2/3)'. '-2/3' }.
		{ '1/3 + 2/3'. '1'}.
		{ '2/3 - 2/3'. '0'}.
		{ '1/3 × 2/5'. '2/15'}.
		{ '3 ÷ 2'. '3/2'}.
		{ '3/2^{2}'. '9/4'}.
		{ '3/2^{0}'. '1'}.
		{ '2/5 < 3/5'. '⊤'}.
		{ '2/5 > 3/5'. '⊥'}.
	}
	collect: [ :each |
		| term result |
		term := context term: each first.
		result := context reduce: term.
		self assert: result equals: (context term: each second).
		{ term. result } ]
]

{ #category : #example }
LzExamples >> rationalNumberTerms [
	<gtExample>
	| context |
	context := LzBuiltinContexts rationalNumberContext.
	^ {
		{ '0'. 'zero'. }.
		{ '1'. 'ℕ.nz' }.
		{ '-1'. 'ℤ.nz' }.
		{ '-1 + 1'. 'ℤ' }.
		{ '1 + 1'. 'ℕ.nz' }.
		{ '1/3'. 'ℚ.p' }.
		{ '-1/3'. 'ℚ.nz' }.
		{ '-1/3 + 1/3'. 'ℚ' }.
		{ '1/3 + 1/3'. 'ℚ.p' }.
	}
	collect: [ :each |
		| term |
		term := context term: each first.
		self assert: term sort asLeibnizSyntaxString equals: each second.
		term  ]
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
		var: 'A_ : A';
		var: 'B_ : B';
		var: 'C_ : C';
		var: 'D_ : D';
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
		op: 'Foo^{Foo} : Foo';
		op: 'Foo\{Foo} : Foo';
		var: 'foo_ : Foo'.
]

{ #category : #example }
LzExamples >> simpleContextRules [
	<gtExample>
	^ {
		'aFoo ⇒ aFoo'.
		'aFoo(foo_) ⇒ aFoo'.
		'∀ someFoo_:Foo aFoo(someFoo_) ⇒ someFoo_'.
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
		{ 'foo_'. 'aFoo'.  {'foo_' -> 'aFoo'} }.
		{ 'foo_'. 'aFoo(aFoo)'.  {'foo_' -> 'aFoo(aFoo)'} }.
		{ 'aFoo(foo_)'. 'aFoo(aFoo)'. {'foo_' -> 'aFoo'} }.
		{ '(foo_ + foo_)'. 'aFoo + aFoo'. {'foo_' -> 'aFoo'} }.
		{ 'aFoo(foo_)'. 'aFoo'. {} }
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
		'aFoo(aFoo(foo_))'.
		'aFoo(aFoo + aFoo)'.
		'aFoo[aFoo]'.
		'aFoo^{aFoo}'.
		'aFoo\{aFoo}'
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
LzExamples >> stringOperations [
	<gtExample>
	| context |
	context := LzBuiltinContexts stringContext.
	^ {
		{ '"" + ""'. '""' }.
		{ '"abc" + "xyz"'. '"abcxyz"'}.
		{ '"abc" + ""'. '"abc"'}.
	}
	collect: [ :each |
		| term result |
		term := context term: each first.
		result := context reduce: term.
		self assert: result equals: (context term: each second).
		{ term. result } ]
]

{ #category : #example }
LzExamples >> stringTerms [
	<gtExample>
	| context |
	context := LzBuiltinContexts stringContext.
	^ {
		{ '""'. 'string'. }.
		{ '"abc"'. 'string' }.
	}
	collect: [ :each |
		| term |
		term := context term: each first.
		self assert: term sort asLeibnizSyntaxString equals: each second.
		term  ]
]

{ #category : #example }
LzExamples >> termsForSignatureWithSubsorts [
	<gtExample>
	^ {
		'anA'. 'aB'. 'aC'. 'aD'.
		"'foo(anA)'. 'foo(aB)'. 'foo(aC)'. 'foo(aD)'."
	} collect: [ :each |
		self signatureWithSubsorts term: each ]
]
