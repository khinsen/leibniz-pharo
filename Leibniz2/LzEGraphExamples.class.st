Class {
	#name : #LzEGraphExamples,
	#superclass : #Object,
	#traits : 'TGtExampleAssertable',
	#classTraits : 'TGtExampleAssertable classTrait',
	#category : #'Leibniz2-EGraphs'
}

{ #category : #examples }
LzEGraphExamples >> contextForEGraphWithEqualities [
	<gtExample>
	^ LzContextBuilder new
		include: self contextForSimpleEGraph;
		axiom: 'a = b';
		axiom: 'b = c';
		context
]

{ #category : #examples }
LzEGraphExamples >> contextForEGraphWithInfiniteRewrites [
	<gtExample>
	^ LzContextBuilder new
		include: self contextForSimpleEGraph;
		axiom: 'a = b + 1';
		axiom: 'b = c + 1';
		axiom: 'c = a + 1';
		context
]

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
LzEGraphExamples >> eGraphWithCycle [
	<gtExample>
	| context nodes egraph |
	context := self contextForSimpleEGraph.
	egraph := LzEGraph new
				context: context.
	egraph
		merge: (egraph addTerm: 'a')
		with: (egraph addTerm: 'a + 1').
	egraph rebuild.
	^ egraph
]

{ #category : #examples }
LzEGraphExamples >> eGraphWithEqualities [
	<gtExample>
	| context nodes egraph |
	context := self contextForEGraphWithEqualities.
	egraph := LzEGraph new
				context: context.
	nodes := { '1'. 'a'. 'a + 1'. 'b'. 'b + 1' } collect: [ :each |
		egraph addTerm: each ].
	egraph addRewritesFromRewriteSystem:
		context rewriteSystemWithEqualityAxioms.
	^ egraph
]

{ #category : #examples }
LzEGraphExamples >> eGraphWithInfiniteRewrites [
	<gtExample>
	| context nodes egraph |
	context := self contextForEGraphWithCycle.
	egraph := LzEGraph new
				context: context.
	egraph addTerm: 'a + 1'.
	egraph addRewritesFromRewriteSystem:
		context rewriteSystemWithEqualityAxioms.
	^ egraph
]

{ #category : #examples }
LzEGraphExamples >> emptyEGraph [
	<gtExample>
	^ LzEGraph new
		context: self contextForSimpleEGraph
]

{ #category : #examples }
LzEGraphExamples >> simpleEGraph [
	<gtExample>
	| nodes egraph |
	egraph := self emptyEGraph.
	nodes := { '1'. 'a'. 'a + 1'. 'b'. 'b + 1' } collect: [ :each |
		egraph addTerm: each ].
	egraph merge: nodes second with: nodes fourth.
	egraph rebuild.
	^ egraph
]
