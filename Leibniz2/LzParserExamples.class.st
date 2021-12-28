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
LzParserExamples >> literalTerms [
	<gtExample>
	^ {
		'42'.
		'2.5e10'. '-1e-3'.
		'2/3'. '-2/3'.
		'"abc"'.
	} collect: [ :each |
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
	} collect: [ :each |
		self opParser parse: each ]
]

{ #category : #accessing }
LzParserExamples >> opParser [
	<gtExample>
	^ LzParser newStartingAt: #op
]

{ #category : #accessing }
LzParserExamples >> simpleTermParser [
	<gtExample>
	^ LzParser newStartingAt: #simpleTermEnd
]

{ #category : #accessing }
LzParserExamples >> simpleTerms [
	<gtExample>
	^ {
		'foo'.
		'?foo'.
		'foo(bar)'.
		'(foo + bar)'.
		'(foo[bar])'.
		'(foo^{bar})'.
		'(foo_{bar})'.
	} collect: [ :each |
		self simpleTermParser parse: each ]
]

{ #category : #accessing }
LzParserExamples >> termParser [
	<gtExample>
	^ LzParser newStartingAt: #termEnd
]

{ #category : #accessing }
LzParserExamples >> terms [
	<gtExample>
	^ {
		'foo + bar'.
		'foo + bar + baz'.
		'foo + (bar + baz)'.
		'foo(bar, baz)'.
		'foo(bar + baz)'.
		'foo[bar]'.
		'foo^{bar}'.
		'foo_{bar}'.
	} collect: [ :each |
		self termParser parse: each ]
]
