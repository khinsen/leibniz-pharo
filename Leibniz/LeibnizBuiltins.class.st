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
	| contextsBuilder |
	contextsBuilder := self newContextBuilderNamed: 'contexts'.
	contextsBuilder include: 'strings' inMode: 'use'.
	contextsBuilder addSort: #context.
	contextsBuilder build.
]

{ #category : #initialization }
LeibnizBuiltins >> createFPContext [
	| fpNumbers |
	fpNumbers := self newContextBuilderNamed: 'IEEE-floating-point'.
	fpNumbers include: 'integers' inMode: 'use'.

	fpNumbers addSort: #FP.
	fpNumbers addSort: #'FP.number'.
	fpNumbers addSort: #'FP.NaN'.
	fpNumbers addSort: #'FP.inf'.
	fpNumbers make: #'FP.number' subsortOf: #'FP'.
	fpNumbers make: #'FP.NaN' subsortOf: #'FP'.
	fpNumbers make: #'FP.inf' subsortOf: #'FP'.

	fpNumbers addSort: #FP32.
	fpNumbers addSort: #'FP32-number'.
	fpNumbers addSort: #'FP32-NaN'.
	fpNumbers addSort: #'FP32-inf'.
	fpNumbers make: #'FP32' subsortOf: #'FP'.
	fpNumbers make: #'FP32-number' subsortOf: #'FP32'.
	fpNumbers make: #'FP32-number' subsortOf: #'FP.number'.
	fpNumbers make: #'FP32-NaN' subsortOf: #'FP32'.
	fpNumbers make: #'FP32-NaN' subsortOf: #'FP.NaN'.
	fpNumbers make: #'FP32-inf' subsortOf: #'FP32'.
	fpNumbers make: #'FP32-inf' subsortOf: #'FP.inf'.

	fpNumbers addSort: #FP64.
	fpNumbers addSort: #'FP64-number'.
	fpNumbers addSort: #'FP64-NaN'.
	fpNumbers addSort: #'FP64-inf'.
	fpNumbers make: #'FP64' subsortOf: #'FP'.
	fpNumbers make: #'FP64-number' subsortOf: #'FP64'.
	fpNumbers make: #'FP64-number' subsortOf: #'FP.number'.
	fpNumbers make: #'FP64-NaN' subsortOf: #'FP64'.
	fpNumbers make: #'FP64-NaN' subsortOf: #'FP.NaN'.
	fpNumbers make: #'FP64-inf' subsortOf: #'FP64'.
	fpNumbers make: #'FP64-inf' subsortOf: #'FP.inf'.
	fpNumbers build.
]

{ #category : #initialization }
LeibnizBuiltins >> createIntegerContext [
	| integers |
	integers := self newContextBuilderNamed: 'integers'.
	integers include: 'truth' inMode: 'use'.
	"Natural numbers"
	integers addSort: #ℕ.
	integers addSort: #zero.
	integers addSort: #'ℕ.nz'.
	integers make: #zero subsortOf: #ℕ.
	integers make: #'ℕ.nz' subsortOf: #ℕ.
	"Integers"
	integers addSort: #ℤ.
	integers addSort: #'ℤ.nz'.
	integers make: #ℕ subsortOf: #ℤ.
	integers make: #'ℤ.nz' subsortOf: #ℤ.
	integers make: #'ℕ.nz' subsortOf: #'ℤ.nz'.
	integers build.
]

{ #category : #initialization }
LeibnizBuiltins >> createRationalContext [
	| rationalNumbers |
	rationalNumbers := self newContextBuilderNamed: 'rational-numbers'.
	rationalNumbers include: 'integers' inMode: 'extend'.
	rationalNumbers addSort: #'ℚ'.
	rationalNumbers make: #'ℤ' subsortOf: 'ℚ'.
	rationalNumbers addSort: #'ℚ.nz'.
	rationalNumbers make: #'ℚ.nz'subsortOf: #'ℚ'.
	rationalNumbers make: #'ℤ.nz'subsortOf: #'ℚ.nz'.
	rationalNumbers addSort: #'ℚ.p'.
	rationalNumbers make: #'ℚ.p'subsortOf: #'ℚ.nz'.
	rationalNumbers make: #'ℕ.nz'subsortOf: #'ℚ.p'.
	rationalNumbers addSort: #'ℚ.nn'.
	rationalNumbers make: #'ℚ.nn'subsortOf: #'ℚ'.
	rationalNumbers make: #'ℚ.p'subsortOf: #'ℚ.nn'.
	rationalNumbers make: #'ℕ'subsortOf: #'ℚ.nn'.
	rationalNumbers build.
]

{ #category : #initialization }
LeibnizBuiltins >> createRealNumberContext [
	| realNumbers |
	realNumbers := self newContextBuilderNamed: 'real-numbers'.
	realNumbers include: 'rational-numbers' inMode: 'extend'.
	realNumbers addSort: #'ℝ'.
	realNumbers make: #'ℚ' subsortOf: #'ℝ'.
	realNumbers addSort: #'ℝ.nz'.
	realNumbers make: #'ℝ.nz' subsortOf: #'ℝ'.
	realNumbers make: #'ℚ.nz' subsortOf: #'ℝ.nz'.
	realNumbers addSort: #'ℝ.p'.
	realNumbers make: #'ℝ.p' subsortOf: #'ℝ.nz'.
	realNumbers make: #'ℚ.p' subsortOf: #'ℝ.p'.
	realNumbers addSort: #'ℝ.nn'.
	realNumbers make: #'ℝ.nn' subsortOf: #'ℝ'.
	realNumbers make: #'ℝ.p' subsortOf: #'ℝ.nn'.
	realNumbers make: #'ℚ.nn' subsortOf: #'ℝ.nn'.
	realNumbers build.
]

{ #category : #initialization }
LeibnizBuiltins >> createStringContext [
	| string |
	string := self newContextBuilderNamed: 'strings'.
	string addSort: #string.
	string build.

]

{ #category : #initialization }
LeibnizBuiltins >> createTruthContext [
	| truth |
	truth := self newContextBuilderNamed: 'truth'.
	truth addSort: #boolean.
	truth build.

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
