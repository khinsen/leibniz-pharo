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
	b := LeibnizSortGraphBuilder new.
	b add: #A;
	  add: #B;
	  make: #B subsortOf: #A;
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
	b addOp: #foo withArgs: #(#Y) ofSort: #Y.
	s := b signature.
	
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
