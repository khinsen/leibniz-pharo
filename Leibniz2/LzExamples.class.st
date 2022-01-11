Class {
	#name : #LzExamples,
	#superclass : #Object,
	#traits : 'TGtExampleAssertable',
	#classTraits : 'TGtExampleAssertable classTrait',
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #accessing }
LzExamples >> bagSortContext [
	<gtExample>
	^ LzContextBuilder new
		include: self listSortContext;
		op: 'collection : 𝕊';
		op: 'bag(𝕊, ℕ) : 𝕊';
		op: 'ℕ : 𝕊';
		axiom: '∀ ?s:𝕊 ∀ ?n:ℕ list(?s, ?n) ⊆ bag(s, n)';
		axiom: '∀ ?s:𝕊 ∀ ?n:ℕ bag(?s, ?n) ⊆ collection';
		axiom: '∅ ⊆ collection';
		context
]

{ #category : #example }
LzExamples >> listSortContext [
	<gtExample>
	^ (LzContextBuilder new
		include: LzBuiltinContexts sortContext;
		sort: 'ℕ';
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
	self assert: ((sortGraph sort: 'A') <= (sortGraph sort: 'B')) not.
	self assert: (sortGraph sort: 'C') <= (sortGraph sort: 'A').
	self assert: (sortGraph sort: 'D') <= (sortGraph sort: 'A').
	^ sortGraph
]
