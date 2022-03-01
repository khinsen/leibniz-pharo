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
LzEGraphExamples >> eGraphWithEqualities [
	<gtExample>
	| context nodes egraph |
	context := self contextForEGraphWithEqualities.
	egraph := LzEGraph new
				context: context.
	nodes := { '1'. 'a'. 'a + 1'. 'b'. 'b + 1' } collect: [ :each |
		(context term: each) asENodeIn: egraph ].
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
		(egraph context term: each) asENodeIn: egraph ].
	egraph merge: nodes second with: nodes fourth.
	egraph rebuild.
	^ egraph
]
