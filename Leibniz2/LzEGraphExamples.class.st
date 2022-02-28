Class {
	#name : #LzEGraphExamples,
	#superclass : #Object,
	#traits : 'TGtExampleAssertable',
	#classTraits : 'TGtExampleAssertable classTrait',
	#category : #'Leibniz2-EGraphs'
}

{ #category : #examples }
LzEGraphExamples >> contextForSimpleEGraph [
	<gtExample>
	^ LzContextBuilder new
		include: LzBuiltinContexts integerContext;
		op: 'a : ℕ';
		op: 'b : ℕ';
		op: 'c : ℕ';
		var: '?x : ℕ';
		context
]

{ #category : #examples }
LzEGraphExamples >> emptyEGraph [
	<gtExample>
	^ LzEGraph new
		signature: self contextForSimpleEGraph signature.
]

{ #category : #examples }
LzEGraphExamples >> simpleEGraph [
	<gtExample>
	| nodes egraph |
	egraph := self emptyEGraph.
	nodes := { '1'. 'a'. 'a + 1'. 'b'. 'b + 1' } collect: [ :each |
		(egraph signature term: each) asENodeIn: egraph ].
	egraph merge: nodes second with: nodes fourth.
	egraph rebuild.
	^ egraph
]
