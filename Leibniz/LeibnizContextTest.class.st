Class {
	#name : #LeibnizContextTest,
	#superclass : #TestCase,
	#category : #Leibniz
}

{ #category : #testing }
LeibnizContextTest >> testGoodDefinition [
	| context |
	context := LeibnizContext new.
	context name: 'foo'.
	context include: 'bar' inMode: 'use'.
	context addSort: #A.
	context addSort: #B.
	context make: #A subsortOf: #B.
	self assert: context name equals: 'foo'.
	self assert: context sortGraph size equals: 2.

]
