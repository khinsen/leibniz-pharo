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
		sort: 'collection';
		sort: 'bag(𝕊, ℕ)';
		subsort: '∀ ?s:𝕊 ∀ ?n:ℕ list(?s, ?n) ⊆ bag(?s, ?n)';
		subsort: '∀ ?s:𝕊 ∀ ?n:ℕ bag(?s, ?n) ⊆ collection';
		subsort: '∅ ⊆ collection';
		op: '∀ ?s:𝕊 ∀ ?n:ℕ ∀ ?m:ℕ (bag(?s, ?n)) ** (bag(?s, ?m)) : bag(?s, ?n + ?m)';
		op: '∀ ?s:𝕊 ∀ ?n:ℕ (bag(?s, ?n)) ** ?s : bag(?s, ?n + 1)';
		op: '∀ ?s:𝕊 ∅ ** ?s : bag(?s, 1)';
		context
]

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

{ #category : #accessing }
LzExamples >> booleanContext [
	<gtExample>
	^ LzContextBuilder new
		include: LzBuiltinContexts truthContext;
		op: '¬(boolean) : boolean';
		op: 'boolean ∧ boolean : boolean';
		op: 'boolean ∨ boolean : boolean';
		op: 'boolean ⊻ boolean : boolean';
		var: '?X : boolean';
		var: '?Y : boolean';
		context
]

{ #category : #example }
LzExamples >> booleanUnifications [
	<gtExample>
	| c |
	c := self booleanContext.
	^ {
		{'true'. '?X'. '(?X=true)'}.
		{'¬(?X)'. '¬(true)'. '(?X=true)'}.
		{'?X'. '¬(true)'. '(?X=¬(true))'}.
		{'true ⊻ false ⊻ true ⊻ ¬(true)'. 'true ⊻ false ⊻ ?X ⊻ ?Y'. '(?X=true, ?Y=¬(true))'}.
		{'false ⊻ ?X ⊻ true ⊻ ¬(true)'. 'false ⊻ true ⊻ ?X ⊻ ?Y'. '(?X=true, ?Y=¬(true))'}.
		{'?X ⊻ ¬(?X)'. 'false ⊻ ¬(?X)'. '(?X=false)'}.
		{'?X ⊻ ¬(?Y)'. 'false ⊻ ¬(?Y)'. '(?Y, ?X=false)'}.
		{'false ⊻ ¬(?X)'. 'false ⊻ ¬(?Y)'. '(?X=?Y)'}.
		{'true'. 'false'.  '(failure #nonUnifiableTerms: false, true)' }.
		{'∀ ?foo:boolean ¬(?foo)'. '∀ ?bar:boolean ¬(?bar)'. '(?bar=?foo)'}
	} collect: [ :each |
		| unification string |
		unification := (c pattern: each first) unify: (c pattern: each  second).
		string := unification printString.
		self assert: (string allButFirst: (string findString: '(') - 1) equals: each third.
		unification ]
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
LzExamples >> listContext [
	<gtExample>
	^ LzContextBuilder new
		includeSortContext: LzBuiltinContexts integerContext;
		sort: 'element';
		sort: 'element.special';
		sort: '∅';
		sort: 'list(𝕊, ℕ)';
		subsort: 'element.special ⊆ element';		
		op: '∅ : ∅';
		op: '∀ ?s:𝕊 ∀ ?n:ℕ ∀ ?m:ℕ ',
				'(list(?s, ?n)) ++ (list(?s, ?m)) : list(?s, ?n + ?m)';
		op: '∀ ?s:𝕊 ∀ ?n:ℕ ',
				'(list(?s, ?n)) ++ ?s : list(?s, ?n + 1)';
		op: '∀ ?s:𝕊 ',
				'∅ ++ ?s : list(?s, 1)';
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

{ #category : #example }
LzExamples >> listTerms [
	<gtExample>
	^ {
		'∅'.
		'∅ ++ 1'.
"		'∅ ++ 1 + 2'."
	}
	collect: [ :each |
		 self listPlusIntegerContext term: each ]
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
LzExamples >> simpleContextTermMatches [
	<gtExample>
	| context |
	context := self simpleContext.
	^ {
		{ '?foo'. 'aFoo'.  {'?foo' -> 'aFoo'} }.
		{ '?foo'. 'aFoo(aFoo)'.  {'?foo' -> 'aFoo(aFoo)'} }.
		{ 'aFoo(?foo)'. 'aFoo(aFoo)'. {'?foo' -> 'aFoo'} }.
		{ '(?foo + ?foo)'. 'aFoo + aFoo'. {'?foo' -> 'aFoo'} }.
		{ 'aFoo(?foo)'. 'aFoo'. {} }
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
