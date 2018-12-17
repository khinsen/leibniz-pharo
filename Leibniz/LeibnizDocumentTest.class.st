Class {
	#name : #LeibnizDocumentTest,
	#superclass : #TestCase,
	#category : #'Leibniz-Tests'
}

{ #category : #testing }
LeibnizDocumentTest >> testGoodContextDefinition [
	| doc context |
	doc := LeibnizDocument new.
	"bar"
	context := doc newContextNamed: 'bar'.
	"foo"
	context := doc newContextNamed: 'foo'.
	context include: 'bar' inMode: 'use'.
	context addSort: #A.
	context addSort: #B.
	context make: #A subsortOf: #B.
	self assert: context name equals: 'foo'.
	self assert: context sortGraph size equals: 2.

]

{ #category : #testing }
LeibnizDocumentTest >> testPhaseErrorInCOntextDefinition [
	| doc context |
	doc := LeibnizDocument new.
	context := doc newContextNamed: 'foo'.
	context addSort: #A.
	self should: [context include: 'bar' inMode: 'use'.]
		  raise: Exception.


]
