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

{ #category : #initialization }
LeibnizBuiltins >> createContextContext [
	| context |
	context := self newContextNamed: 'contexts'.
	context include: 'strings' inMode: 'use'.
	context addSort: #context.

]

{ #category : #initialization }
LeibnizBuiltins >> createFPContext [
	| context |
	context := self newContextNamed: 'IEEE-floating-point'.
	context include: 'integers' inMode: 'use'.

	context addSort: #FP.
	context addSort: #'FP.number'.
	context addSort: #'FP.NaN'.
	context addSort: #'FP.inf'.
	context make: #'FP.number' subsortOf: #'FP'.
	context make: #'FP.NaN' subsortOf: #'FP'.
	context make: #'FP.inf' subsortOf: #'FP'.

	context addSort: #FP32.
	context addSort: #'FP32-number'.
	context addSort: #'FP32-NaN'.
	context addSort: #'FP32-inf'.
	context make: #'FP32' subsortOf: #'FP'.
	context make: #'FP32-number' subsortOf: #'FP32'.
	context make: #'FP32-number' subsortOf: #'FP.number'.
	context make: #'FP32-NaN' subsortOf: #'FP32'.
	context make: #'FP32-NaN' subsortOf: #'FP.NaN'.
	context make: #'FP32-inf' subsortOf: #'FP32'.
	context make: #'FP32-inf' subsortOf: #'FP.inf'.

	context addSort: #FP64.
	context addSort: #'FP64-number'.
	context addSort: #'FP64-NaN'.
	context addSort: #'FP64-inf'.
	context make: #'FP64' subsortOf: #'FP'.
	context make: #'FP64-number' subsortOf: #'FP64'.
	context make: #'FP64-number' subsortOf: #'FP.number'.
	context make: #'FP64-NaN' subsortOf: #'FP64'.
	context make: #'FP64-NaN' subsortOf: #'FP.NaN'.
	context make: #'FP64-inf' subsortOf: #'FP64'.
	context make: #'FP64-inf' subsortOf: #'FP.inf'.
]

{ #category : #initialization }
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

{ #category : #initialization }
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

{ #category : #initialization }
LeibnizBuiltins >> createRealNumberContext [
	| context |
	context := self newContextNamed: 'real-numbers'.
	context include: 'rational-numbers' inMode: 'extend'.
	context addSort: #'ℝ'.
	context make: #'ℚ' subsortOf: #'ℝ'.
	context addSort: #'ℝ.nz'.
	context make: #'ℝ.nz' subsortOf: #'ℝ'.
	context make: #'ℚ.nz' subsortOf: #'ℝ.nz'.
	context addSort: #'ℝ.p'.
	context make: #'ℝ.p' subsortOf: #'ℝ.nz'.
	context make: #'ℚ.p' subsortOf: #'ℝ.p'.
	context addSort: #'ℝ.nn'.
	context make: #'ℝ.nn' subsortOf: #'ℝ'.
	context make: #'ℝ.p' subsortOf: #'ℝ.nn'.
	context make: #'ℚ.nn' subsortOf: #'ℝ.nn'.

]

{ #category : #initialization }
LeibnizBuiltins >> createStringContext [
	| string |
	string := self newContextNamed: 'strings'.
	string addSort: #string.

]

{ #category : #initialization }
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
	self createRealNumberContext.
	self createStringContext.
	self createContextContext.
	self createFPContext.
	library addDocument: self.

]
