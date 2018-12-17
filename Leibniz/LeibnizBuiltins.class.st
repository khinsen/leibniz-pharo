"
My unique instance is a special document that contains the built-in contexts of Leibniz.
"
Class {
	#name : #LeibnizBuiltins,
	#superclass : #LeibnizDocument,
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'Leibniz-Core'
}

{ #category : #accessing }
LeibnizBuiltins class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self new ]
]

{ #category : #initializing }
LeibnizBuiltins >> createIntegerContext [
	| context |
	context := self newContextNamed: 'integers'.
	context include: 'truth' inMode: 'use'.
	"Natural numbers"
	context addSort: #ℕ.
	context addSort: #zero.
	context addSort: #'ℕ.nz'.
	context make: #zero subsortOf: #ℕ.
	context make: #'ℕ.nz' subsortOf: #ℕ.
	"Integers"
	context addSort: #ℤ.
	context addSort: #'ℤ.nz'.
	context make: #ℕ subsortOf: #ℤ.
	context make: #'ℤ.nz' subsortOf: #ℤ.
	context make: #'ℕ.nz' subsortOf: #'ℤ.nz'.

]

{ #category : #initializing }
LeibnizBuiltins >> createRationalContext [
	| context |
	context := self newContextNamed: 'rational-numbers'.
	context include: 'integers' inMode: 'extend'.
	context addSort: #'ℚ'.
	context make: #'ℤ' subsortOf: 'ℚ'.
	context addSort: #'ℚ.nz'.
	context make: #'ℚ.nz'subsortOf: #'ℚ'.
	context make: #'ℤ.nz'subsortOf: #'ℚ.nz'.
	context addSort: #'ℚ.p'.
	context make: #'ℚ.p'subsortOf: #'ℚ.nz'.
	context make: #'ℕ.nz'subsortOf: #'ℚ.p'.
	context addSort: #'ℚ.nn'.
	context make: #'ℚ.nn'subsortOf: #'ℚ'.
	context make: #'ℚ.p'subsortOf: #'ℚ.nn'.
	context make: #'ℕ'subsortOf: #'ℚ.nn'.

]

{ #category : #initializing }
LeibnizBuiltins >> createTruthContext [
	| truth |
	truth := self newContextNamed: 'truth'.
	truth addSort: #boolean.
	
]

{ #category : #initialization }
LeibnizBuiltins >> initialize [
	super initialize.
	self docHash: (SHA256 hashMessage: 'builtins') hex.
	self createTruthContext.
	self createIntegerContext.
	self createRationalContext.
	library add: self.

]
