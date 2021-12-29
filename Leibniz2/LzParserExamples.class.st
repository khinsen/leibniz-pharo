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
		'foo(?bar:Bar) : Foo(Bar)'.
		'foo(Bar, Baz) : Foo(Bar, Baz)'.
		'Foo[Bar] : Baz'.
		'Foo^{Bar} : Baz'.
		'Foo_{Bar} : Baz'.
		'Foo + Bar : Baz'.
		'boolean ∨ boolean : boolean'.
		'bag(?element:Sort, ?n:ℕ) : Sort'.
	} collect: [ :each |
		self opParser parse: each ]
]

{ #category : #accessing }
LzParserExamples >> opParser [
	<gtExample>
	^ LzParser newStartingAt: #op
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
		'∀ ?bar:Bar foo(?bar)'.
		'∀ ?foo:Foo ∀ ?bar:Bar (?foo + ?bar)'.
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
		'?foo'.
		'foo(bar)'.
		'(foo + bar)'.
		'(foo[bar])'.
		'(foo^{bar})'.
		'(foo_{bar})'.
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
		'∀ ?s:sort ∀ ?n:ℕ list(s, n) ⊆ bag(s, n)'
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
		'foo_{bar}'.
	}
]

{ #category : #accessing }
LzParserExamples >> terms [
	<gtExample>
	^ self termStrings
		collect: [ :each |
			self termParser parse: each ]
]
