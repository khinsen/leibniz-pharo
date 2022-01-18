Class {
	#name : #LzExamples,
	#superclass : #Object,
	#traits : 'TGtExampleAssertable',
	#classTraits : 'TGtExampleAssertable classTrait',
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #example }
LzExamples >> bagSignature [
	<gtExample>
	^ LzSignatureBuilder new
		sortGraph: self bagSortGraph;
		include: self listSignature;
		op: '∀ ?s:𝕊 ∀ ?n:ℕ ∀ ?m:ℕ (bag(?s, ?n)) ** (bag(?s, ?m)) : bag(?s, ?n + ?m)';
		op: '∀ ?s:𝕊 ∀ ?n:ℕ (bag(?s, ?n)) ** ?s : bag(?s, ?n + 1)';
		op: '∀ ?s:𝕊 ∅ ** ?s : bag(?s, 1)';
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
		axiom: '∀ ?s:𝕊 ∀ ?n:ℕ list(?s, ?n) ⊆ bag(?s, ?n)';
		axiom: '∀ ?s:𝕊 ∀ ?n:ℕ bag(?s, ?n) ⊆ collection';
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
LzExamples >> integerTerms [
	<gtExample>
	^ {
		'0'.
		'1'.
		'-1'.
	}
	collect: [ :each |
		 LzBuiltinContexts integerContext term: each ]
]

{ #category : #example }
LzExamples >> listSignature [
	<gtExample>
	^ LzSignatureBuilder new
		sortGraph: self listSortGraph;
		op: '∅ : ∅';
		op: '∀ ?s:𝕊 ∀ ?n:ℕ ∀ ?m:ℕ ',
				'(list(?s, ?n)) ++ (list(?s, ?m)) : list(?s, ?n + ?m)';
		op: '∀ ?s:𝕊 ∀ ?n:ℕ ',
				'(list(?s, ?n)) ++ ?s : list(?s, ?n + 1)';
		op: '∀ ?s:𝕊 ',
				'∅ ++ ?s : list(?s, 1)';
		op: 'anElement : element';
		signature
]

{ #category : #example }
LzExamples >> listSortContext [
	<gtExample>
	self flag: #todo.
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
		var: '?A : A';
		var: '?B : B';
		var: '?C : C';
		var: '?D : D';
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
		op: 'Foo_{Foo} : Foo';
		var: '?foo : Foo'.
]

{ #category : #example }
LzExamples >> simpleContextTerms [
	<gtExample>
	^ {
		'aFoo'.
		'aFoo(aFoo)'.
		'aFoo(aFoo(?foo))'.
		'aFoo(aFoo + aFoo)'.
		'aFoo[aFoo]'.
		'aFoo^{aFoo}'.
		'aFoo_{aFoo}'
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
		"'foo(anA)'. 'foo(aB)'. 'foo(aC)'. 'foo(aD)'."
	} collect: [ :each |
		self signatureWithSubsorts term: each ]
]
