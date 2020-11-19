"
My unique instance is a special document that contains the built-in contexts of Leibniz.
"
Class {
	#name : #LeibnizBuiltins,
	#superclass : #LeibnizDocument,
	#category : #'Leibniz-7-Documents'
}

{ #category : #initialization }
LeibnizBuiltins >> createContextContext [
	| contextsBuilder |
	contextsBuilder := self newContextBuilderNamed: 'contexts'.
	contextsBuilder include: 'strings' inMode: 'use'.
	contextsBuilder addSort: #context.
	contextsBuilder addOp: #context withArgs: #(#string) ofSort: #context.
	contextsBuilder addOp: #context withArgs: #(#string #string) ofSort: #context.
	contextsBuilder addOp: #'replace-sort' withArgs: #(#context #string #string) ofSort: #context.
	contextsBuilder addOp: #'replace-sort-prefix' withArgs: #(#context #string #string) ofSort: #context.
	contextsBuilder addOp: #'replace-include' withArgs: #(#context #context #context) ofSort: #context.
	contextsBuilder addOp: #'remove-vars' withArgs: #(#context) ofSort: #context.
	contextsBuilder build.
]

{ #category : #initialization }
LeibnizBuiltins >> initialize [
	super initialize.
	self docHash: (SHA256 hashMessage: 'builtins') hex.
	self createTruthContext.
	self createIntegerContext.
	self createRationalContext.
	self createRealNumberContext.
	self createStringContext.
	self createContextContext.
	self createFPContext.

]
