Class {
	#name : #LeibnizSignatureTest,
	#superclass : #TestCase,
	#instVars : [
		'builder',
		'sortGraph'
	],
	#category : #'Leibniz-Tests'
}

{ #category : #running }
LeibnizSignatureTest >> setUp [
	| b |
	super setUp.
	b := LbSortGraphBuilder new.
	b add: #A;
	  add: #B;
	  make: #B subsortOf: #A;
	  add: #V;
	  add: #W;
	  make: #W subsortOf: #V;
	  add: #X;
	  add: #Y;
	  make: #Y subsortOf: #X.
	sortGraph := b sortGraph.

	builder := LeibnizSignatureBuilder sortGraph: sortGraph.

]

{ #category : #testing }
LeibnizSignatureTest >> testArities [
	| arityFor |
	arityFor := [ :args | LeibnizArity sortGraph: sortGraph argSorts: args ].
	self assert: ((arityFor value: #(#B)) <= (arityFor value: #(#A))).
	self deny:   ((arityFor value: #(#A)) <= (arityFor value: #(#B))).
	self assert: ((arityFor value: #(#B #Y)) <= (arityFor value: #(#A #X))).
	self deny: 	 ((arityFor value: #(#B #X)) <= (arityFor value: #(#A #Y))).
	self deny: 	 ((arityFor value: #(#B)) <= (arityFor value: #(#X))).
	self deny: 	 ((arityFor value: #(#A #B)) <= (arityFor value: #(#X))).

]

{ #category : #testing }
LeibnizSignatureTest >> testBasics [
	| b s |
	b := LeibnizSignatureBuilder sortGraph: sortGraph.
	b addOp: #foo withArgs: #(#A) ofSort: #A.
	b addOp: #foo withArgs: #(#B) ofSort: #B.
	b addOp: #foo withArgs: #(#W) ofSort: #W.
	b addOp: #foo withArgs: #(#X) ofSort: #X.
	s := b signature.
	self assert: (s ranksMatchingfOp: #foo withArgs: #(#A)) size equals: 1.
	self assert: (s ranksMatchingfOp: #foo withArgs: #(#B)) size equals: 2.
	self assert: (s ranksMatchingfOp: #foo withArgs: #(#X)) size equals: 1.
	self assert: (s ranksMatchingfOp: #foo withArgs: #(#Y)) size equals: 1.
	self assert: (s ranksMatchingfOp: #foo withArgs: #(#V)) size equals: 0.
	self assert: (s sortOfOp: #foo withArgSorts: #(#A)) equals: #A.
	self assert: (s sortOfOp: #foo withArgSorts: #(#B)) equals: #B.
	self assert: (s sortOfOp: #foo withArgSorts: #(#Y)) equals: #X.
	self assert: (s sortOfOp: #foo withArgSorts: #(#V)) equals: (s sortGraph kindOf: #V).

]

{ #category : #testing }
LeibnizSignatureTest >> testConflictingSorts [
	| b |
	b := LeibnizSignatureBuilder sortGraph: sortGraph.
	b addOp: #foo withArgs: #(#A) ofSort: #A.
	b addVar: #bar ofSort: #A.
	self should: [ b addOp: #foo withArgs: #(#A) ofSort: #B ] raise: Error.
	self should: [ b addVar: #bar ofSort: #B ] raise: Error.

]

{ #category : #testing }
LeibnizSignatureTest >> testNameConflict [
	| b |
	b := LeibnizSignatureBuilder sortGraph: sortGraph.
	b addOp: #foo ofSort: #A.
	b addVar: #bar ofSort: #A.
	self should: [ b addVar: #foo ofSort: #A ] raise: Error.
	self should: [ b addOp: #bar ofSort: #A ] raise: Error.

]

{ #category : #testing }
LeibnizSignatureTest >> testNonMonotonicOp [
	| b |
	b := LeibnizSignatureBuilder sortGraph: sortGraph.
	b addOp: #foo withArgs: #(#A) ofSort: #B.
	self should: [ b addOp: #foo withArgs: #(#B) ofSort: #A ]
		  raise: Error.

]

{ #category : #testing }
LeibnizSignatureTest >> testSignatureParser [
	| b s st |
	b := LeibnizSignatureBuilder sortGraph: sortGraph.
	b addOp: #foo ofSort: #A.
	b addVar: #bar ofSort: #A.
	b addOp: #foo withArgs: #(#A) ofSort: #A.
	b addOp: #'_+' withArgs:#(#A #A)  ofSort: #A.
	s := b signature.
	b := LeibnizSignatureBuilder sortGraph: sortGraph.
	b parseAndAddOp: 'foo : A'.
	b parseAndAddOp: 'foo(bar:A) : A'.
	b parseAndAddOp: 'A + A : A'.
	st := b signature.
	self assert: b signature equals: s
]
