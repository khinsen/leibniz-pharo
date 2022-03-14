Class {
	#name : #LzParserExamples,
	#superclass : #Object,
	#traits : 'TGtExampleAssertable',
	#classTraits : 'TGtExampleAssertable classTrait',
	#category : #'Leibniz2-Parser'
}

{ #category : #accessing }
LzParserExamples >> literalTermParser [
	<gtExample>
	^ LzParser newStartingAt: #literalTermEnd
]

{ #category : #accessing }
LzParserExamples >> literalTermStrings [
	<gtExample>
	^ {
		'42'. '-42'. '0'. '-0'.
		'2.5e10'. '-1e-3'.
		'2/3'. '-2/3'.
		'"abc"'. '""'.
	}
]

{ #category : #accessing }
LzParserExamples >> literalTerms [
	<gtExample>
	^ self literalTermStrings
		collect: [ :each |
			self literalTermParser parse: each ]
]

{ #category : #accessing }
LzParserExamples >> opDeclarations [
	<gtExample>
	^ {
		'foo : Foo'.
		'foo(Bar) : Foo(Bar)'.
		'foo(bar_:Bar) : Foo(Bar)'.
		'foo(Bar, Baz) : Foo(Bar, Baz)'.
		'Foo[Bar] : Baz'.
		'Foo^{Bar} : Baz'.
		'Foo\{Bar} : Baz'.
		'Foo + Bar : Baz'.
		'boolean ∨ boolean : boolean'.
		'bag(element_:Sort, n_:ℕ) : Sort'.
		'∀ s_:sort ∀ n_:ℕ ∀ m_:ℕ (list(s_, n_)) ++ (list(s_, m_)) : list(s_, n_ + m_)'.
	} collect: [ :each |
		| astNode |
		astNode := self opParser parse: each.
		self
			assert: (self opParser parse:  astNode asLeibnizSyntaxString)
			equals: astNode.
		astNode ]
]

{ #category : #accessing }
LzParserExamples >> opParser [
	<gtExample>
	^ LzParser newStartingAt: #opEnd
]

{ #category : #accessing }
LzParserExamples >> patternParser [
	<gtExample>
	^ LzParser newStartingAt: #patternEnd
]

{ #category : #accessing }
LzParserExamples >> patternStrings [
	<gtExample>
	^ self simpleTermStrings,
	{
		'?bar'.
		'∀ ?bar:Bar foo(?bar)'.
		'∀ ?foo:Foo ∀ ?bar:Bar (?foo + ?bar)'.
		'∀ ?l:(∀ ?n:ℕ.nz list(?n)) tail(l)'.
	}
]

{ #category : #accessing }
LzParserExamples >> patterns [
	<gtExample>
	^ self patternStrings
		collect: [ :each |
			self patternParser parse: each ]
]

{ #category : #accessing }
LzParserExamples >> ruleParser [
	<gtExample>
	^ LzParser newStartingAt: #ruleEnd
]

{ #category : #accessing }
LzParserExamples >> ruleStrings [
	<gtExample>
	^ {
		'a ⇒ b'.
		'a ⇒ b | true'.
		'∀ bar_:Bar foo(bar_) ⇒ fooBar'.
		'∀ bar_:Bar foo(bar_) ⇒ fooBar | false'.
		'∀ bar_:Bar ∀ baz_:Baz foo(bar_, baz_) ⇒ fooBar | baz_'.
		'foo(bar_) → ''bar_'':fn'.
	}
]

{ #category : #accessing }
LzParserExamples >> rules [
	<gtExample>
	^ self ruleStrings
		collect: [ :each |
			| parsedRule |
			parsedRule := self ruleParser parse: each.
			self assert: parsedRule asLeibnizSyntaxString equals: each.
			parsedRule ]
]

{ #category : #accessing }
LzParserExamples >> simpleTermParser [
	<gtExample>
	^ LzParser newStartingAt: #simpleTermEnd
]

{ #category : #accessing }
LzParserExamples >> simpleTermStrings [
	<gtExample>
	^ self literalTermStrings,
	{
		'foo'.
		'foo_'.
		'foo(bar)'.
		'(foo + bar)'.
		'(foo[bar])'.
		'(foo^{bar})'.
		'(foo\{bar})'.
	}
]

{ #category : #accessing }
LzParserExamples >> simpleTerms [
	<gtExample>
	^ self simpleTermStrings
		collect: [ :each |
			self simpleTermParser parse: each ]
]

{ #category : #accessing }
LzParserExamples >> subsortAxiomStrings [
	<gtExample>
	^ {
		'A ⊆ B'.
		'∀ ?s:𝕊 ∀ ?n:ℕ list(?s, ?n) ⊆ bag(?s, ?n)'
	}
]

{ #category : #accessing }
LzParserExamples >> subsortAxioms [
	<gtExample>
	^ self subsortAxiomStrings
		collect: [ :each |
			self subsortParser parse: each ]
]

{ #category : #accessing }
LzParserExamples >> subsortParser [
	<gtExample>
	^ LzParser newStartingAt: #subsortAxiomEnd
]

{ #category : #accessing }
LzParserExamples >> termParser [
	<gtExample>
	^ LzParser newStartingAt: #termEnd
]

{ #category : #accessing }
LzParserExamples >> termStrings [
	<gtExample>
	^ self simpleTermStrings,
	{
		'foo + bar'.
		'foo + bar + baz'.
		'foo + (bar + baz)'.
		'foo(bar, baz)'.
		'foo(bar + baz)'.
		'foo[bar]'.
		'foo^{bar}'.
		'foo\{bar}'.
	}
]

{ #category : #accessing }
LzParserExamples >> terms [
	<gtExample>
	^ self termStrings
		collect: [ :each |
			| astNode |
			astNode := self termParser parse: each.
			self
				assert: (self termParser parse:  astNode asLeibnizSyntaxString)
				equals: astNode.
			astNode ]
]

{ #category : #accessing }
LzParserExamples >> varDeclarations [
	<gtExample>
	^ {
		'foo_: Foo'.
		'list_ : ∀ n_:ℕ list(n_)'.
	} collect: [ :each |
		| astNode |
		astNode := self varParser parse: each.
		self assert: astNode isPetit2Failure not.
		self
			assert: (self varParser parse:  astNode asLeibnizSyntaxString)
			equals: astNode.
		astNode ]
]

{ #category : #accessing }
LzParserExamples >> varParser [
	<gtExample>
	^ LzParser newStartingAt: #varEnd
]
