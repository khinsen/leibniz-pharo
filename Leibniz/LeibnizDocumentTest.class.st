Class {
	#name : #LeibnizDocumentTest,
	#superclass : #TestCase,
	#category : #'Leibniz-Tests'
}

{ #category : #testing }
LeibnizDocumentTest >> testGoodContextDefinition [
	| doc builder |
	doc := LeibnizDocument new.
	"bar"
	builder := doc newContextBuilderNamed: 'bar'.
	builder build.
	"foo"
	builder := doc newContextBuilderNamed: 'foo'.
	builder addSort: #A.
	builder addSort: #B.
	builder make: #A subsortOf: #B.
	self assert: builder name equals: 'foo'.
	self assert: builder context sortGraph size equals: 2.
	builder build.

]

{ #category : #testing }
LeibnizDocumentTest >> testPhaseErrorInCOntextDefinition [
	| doc builder |
	doc := LeibnizDocument new.
	builder := doc newContextBuilderNamed: 'foo'.
	builder addSort: #A.
	self should: [builder include: 'bar' inMode: 'use'.]
		  raise: Exception.


]
