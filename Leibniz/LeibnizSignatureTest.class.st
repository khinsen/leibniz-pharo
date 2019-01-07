Class {
	#name : #LeibnizSignatureTest,
	#superclass : #TestCase,
	#instVars : [
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

]

{ #category : #testing }
LeibnizSignatureTest >> testBasics [
	| b s |
	b := LeibnizSignatureBuilder sortGraph: sortGraph.
	b addOp: #foo withArgs: #(#A) ofSort: #A.
	b addOp: #foo withArgs: #(#B) ofSort: #B.
	b addOp: #foo withArgs: #(#Y) ofSort: #Y.
	"s := b signature."
	
]

{ #category : #testing }
LeibnizSignatureTest >> testConflictingSorts [
	| b |
	b := LeibnizSignatureBuilder sortGraph: sortGraph.
	b addOp: #foo withArgs: #(#A) ofSort: #A.
	self should: [ b addOp: #foo withArgs: #(#A) ofSort: #B ] raise: Error.
	
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
