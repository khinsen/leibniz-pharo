Class {
	#name : #LzExamples,
	#superclass : #Object,
	#traits : 'TGtExampleAssertable',
	#classTraits : 'TGtExampleAssertable classTrait',
	#category : #'Leibniz2-Leibniz2'
}

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
		op: 'Foo_{Foo} : Foo'.
]

{ #category : #example }
LzExamples >> simpleContextTerms [
	<gtExample>
	^ {
		'aFoo'.
		'aFoo(aFoo)'.
		'aFoo(aFoo(aFoo))'.
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
