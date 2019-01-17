"
My unique instance is a special document that contains the built-in contexts of Leibniz.
"
Class {
	#name : #LeibnizBuiltins,
	#superclass : #LeibnizDocument,
	#category : #'Leibniz-Core'
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
LeibnizBuiltins >> createFPContext [
	| fpNumbers |
	fpNumbers := self newContextBuilderNamed: 'IEEE-floating-point'.
	fpNumbers include: 'integers' inMode: 'use'.
	"Generic FP Sorts"
	fpNumbers addSort: #FP.
	fpNumbers addSort: #'FP.number'.
	fpNumbers addSort: #'FP.NaN'.
	fpNumbers addSort: #'FP.inf'.
	fpNumbers make: #'FP.number' subsortOf: #'FP'.
	fpNumbers make: #'FP.NaN' subsortOf: #'FP'.
	fpNumbers make: #'FP.inf' subsortOf: #'FP'.
	"Single-precision FP sorts"
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
	"Double-precision FP sorts"
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
	"Arithmetic operators, single precision"
	fpNumbers addOp: #'_+' withArgs: #(#FP32 #FP32) ofSort: #FP32.
	fpNumbers addOp: #'_-' withArgs: #(#FP32 #FP32) ofSort: #FP32.
	fpNumbers addOp: #'-' withArgs: #(#FP32) ofSort: #FP32.
	fpNumbers addOp: #'_×' withArgs: #(#FP32 #FP32) ofSort: #FP32.
	fpNumbers addOp: #'_÷' withArgs: #(#FP32 #FP32) ofSort: #FP32.
	fpNumbers addOp: #'^' withArgs: #(#FP32 #FP32) ofSort: #FP32.
	fpNumbers addOp: #'^' withArgs: #(#FP32 #'ℤ') ofSort: #FP32.
	fpNumbers addOp: #'abs' withArgs: #(#FP32) ofSort: #FP32.
	fpNumbers addOp: #'√' withArgs: #(#FP32) ofSort: #FP32.
	"Arithmetic operators, double precision"
	fpNumbers addOp: #'_+' withArgs: #(#FP64 #FP64) ofSort: #FP64.
	fpNumbers addOp: #'_-' withArgs: #(#FP64 #FP64) ofSort: #FP64.
	fpNumbers addOp: #'-' withArgs: #(#FP64) ofSort: #FP64.
	fpNumbers addOp: #'_×' withArgs: #(#FP64 #FP64) ofSort: #FP64.
	fpNumbers addOp: #'_÷' withArgs: #(#FP64 #FP64) ofSort: #FP64.
	fpNumbers addOp: #'^' withArgs: #(#FP64 #FP64) ofSort: #FP64.
	fpNumbers addOp: #'^' withArgs: #(#FP64 #'ℤ') ofSort: #FP64.
	fpNumbers addOp: #'abs' withArgs: #(#FP64) ofSort: #FP64.
	fpNumbers addOp: #'√' withArgs: #(#FP64) ofSort: #FP64.
	"Comparison operators, single precision"
	fpNumbers addOp: #'_=' withArgs: #(#FP32 #FP32) ofSort: #boolean.
	fpNumbers addOp: #'_<' withArgs: #(#FP32 #FP32) ofSort: #boolean.
	fpNumbers addOp: #'_>' withArgs: #(#FP32 #FP32) ofSort: #boolean.
	fpNumbers addOp: #'_≤' withArgs: #(#FP32 #FP32) ofSort: #boolean.
	fpNumbers addOp: #'_≥' withArgs: #(#FP32 #FP32) ofSort: #boolean.
	"Comparison operators, double precision"
	fpNumbers addOp: #'_=' withArgs: #(#FP64 #FP64) ofSort: #boolean.
	fpNumbers addOp: #'_<' withArgs: #(#FP64 #FP64) ofSort: #boolean.
	fpNumbers addOp: #'_>' withArgs: #(#FP64 #FP64) ofSort: #boolean.
	fpNumbers addOp: #'_≤' withArgs: #(#FP64 #FP64) ofSort: #boolean.
	fpNumbers addOp: #'_≥' withArgs: #(#FP64 #FP64) ofSort: #boolean.
	"Build the context"
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
	"Arithmetic operators"
	integers addOp: #'_+' withArgs: #(#'ℤ' #'ℤ') ofSort: #'ℤ'.
	integers addOp: #'_+' withArgs: #(#'ℕ' #'ℕ') ofSort: #'ℕ'.
	integers addOp: #'_+' withArgs: #(#'ℕ.nz' #'ℕ') ofSort: #'ℕ.nz'.
	integers addOp: #'_+' withArgs: #(#'ℕ' #'ℕ.nz') ofSort: #'ℕ.nz'.
	integers addOp: #'_-' withArgs: #(#'ℤ' #'ℤ') ofSort: #'ℤ'.
	integers addOp: #'-' withArgs: #(#'ℤ') ofSort: #'ℤ'.
	integers addOp: #'_×' withArgs: #(#'ℤ' #'ℤ') ofSort: #'ℤ'.
	integers addOp: #'_×' withArgs: #(#'ℕ' #'ℕ') ofSort: #'ℕ'.
	integers addOp: #'_×' withArgs: #(#'ℕ.nz' #'ℕ.nz') ofSort: #'ℕ.nz'.
	integers addOp: #'_×' withArgs: #(#'ℤ.nz' #'ℤ.nz') ofSort: #'ℤ.nz'.
	integers addOp: #'_div' withArgs: #(#'ℤ' #'ℤ.nz') ofSort: #'ℤ'.
	integers addOp: #'_div' withArgs: #(#'ℕ' #'ℕ.nz') ofSort: #'ℕ'.
	integers addOp: #'_rem' withArgs: #(#'ℤ' #'ℤ.nz') ofSort: #'ℤ'.
	integers addOp: #'_rem' withArgs: #(#'ℕ' #'ℕ.nz') ofSort: #'ℕ'.
	integers addOp: #'^' withArgs: #(#'ℤ' #'ℕ.nz') ofSort: #'ℤ'.
	integers addOp: #'^' withArgs: #(#'ℕ' #'ℕ.nz') ofSort: #'ℕ'.
	integers addOp: #'^' withArgs: #(#'ℕ.nz' #'ℕ.nz') ofSort: #'ℕ.nz'.
	integers addOp: #'^' withArgs: #(#'ℤ.nz' #'ℕ.nz') ofSort: #'ℤ.nz'.
	integers addOp: #'^' withArgs: #(#'ℤ.nz' #zero) ofSort: #'ℕ.nz'.
	integers addOp: #abs withArgs: #(#'ℤ') ofSort: #'ℕ'.
	integers addOp: #abs withArgs: #(#'ℤ.nz') ofSort: #'ℕ.nz'.
	"Comparison operators"
	integers addOp: #'_=' withArgs: #(#'ℤ' #'ℤ') ofSort: #boolean.
	integers addOp: #'_<' withArgs: #(#'ℤ' #'ℤ') ofSort: #boolean.
	integers addOp: #'_>' withArgs: #(#'ℤ' #'ℤ') ofSort: #boolean.
	integers addOp: #'_≤' withArgs: #(#'ℤ' #'ℤ') ofSort: #boolean.
	integers addOp: #'_≥' withArgs: #(#'ℤ' #'ℤ') ofSort: #boolean.
	"Build context"
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
	"Arithmetic operators"
	rationalNumbers addOp: #'_+' withArgs: #(#'ℚ' #'ℚ') ofSort: #'ℚ'.
	rationalNumbers addOp: #'_+' withArgs: #(#'ℚ.p' #'ℚ.p') ofSort: #'ℚ.p'.
	rationalNumbers addOp: #'_+' withArgs: #(#'ℚ.nn' #'ℚ.nn') ofSort: #'ℚ.nn'.
	rationalNumbers addOp: #'_-' withArgs: #(#'ℚ' #'ℚ') ofSort: #'ℚ'.
	rationalNumbers addOp: #'-' withArgs: #(#'ℚ') ofSort: #'ℚ'.
	rationalNumbers addOp: #'_×' withArgs: #(#'ℚ' #'ℚ') ofSort: #'ℚ'.
	rationalNumbers addOp: #'_×' withArgs: #(#'ℚ.p' #'ℚ.p') ofSort: #'ℚ.p'.
	rationalNumbers addOp: #'_×' withArgs: #(#'ℚ.nn' #'ℚ.nn') ofSort: #'ℚ.nn'.
	rationalNumbers addOp: #'_×' withArgs: #(#'ℚ.nz' #'ℚ.nz') ofSort: #'ℚ.nz'.
	rationalNumbers addOp: #'_÷' withArgs: #(#'ℚ' #'ℚ.nz') ofSort: #'ℚ'.
	rationalNumbers addOp: #'_÷' withArgs: #(#'ℚ.nz' #'ℚ.nz') ofSort: #'ℚ.nz'.
	rationalNumbers addOp: #'_÷' withArgs: #(#'ℚ.nn' #'ℚ.p') ofSort: #'ℚ.nn'.
	rationalNumbers addOp: #'_÷' withArgs: #(#'ℚ.p' #'ℚ.p') ofSort: #'ℚ.p'.
	rationalNumbers addOp: #'^' withArgs: #(#'ℚ.nz' #'ℤ.nz') ofSort: #'ℚ.nz'.
	rationalNumbers addOp: #'^' withArgs: #(#'ℚ.p' #'ℤ.nz') ofSort: #'ℚ.p'.
	rationalNumbers addOp: #'^' withArgs: #(#'ℚ.nz' #'zero') ofSort: #'ℕ.nz'.
	rationalNumbers addOp: #'abs' withArgs: #(#'ℚ') ofSort: #'ℚ.nn'.
	rationalNumbers addOp: #'abs' withArgs: #(#'ℚ.nz') ofSort: #'ℚ.p'.
	"Comparison operators"
	rationalNumbers addOp: #'_=' withArgs: #(#'ℚ' #'ℚ') ofSort: #boolean.
	rationalNumbers addOp: #'_<' withArgs: #(#'ℚ' #'ℚ') ofSort: #boolean.
	rationalNumbers addOp: #'_>' withArgs: #(#'ℚ' #'ℚ') ofSort: #boolean.
	rationalNumbers addOp: #'_≤' withArgs: #(#'ℚ' #'ℚ') ofSort: #boolean.
	rationalNumbers addOp: #'_≥' withArgs: #(#'ℚ' #'ℚ') ofSort: #boolean.
	"Build context"
	rationalNumbers build.
]

{ #category : #initialization }
LeibnizBuiltins >> createRealNumberContext [
	| realNumbers |
	realNumbers := self newContextBuilderNamed: 'real-numbers'.
	realNumbers include: 'rational-numbers' inMode: 'extend'.
	"Sorts"
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
	"Arithmetic operators"
	realNumbers addOp: #'_+' withArgs: #(#'ℝ' #'ℝ') ofSort: #'ℝ'.
	realNumbers addOp: #'_+' withArgs: #(#'ℝ.p' #'ℝ.p') ofSort: #'ℝ.p'.
	realNumbers addOp: #'_+' withArgs: #(#'ℝ.nn' #'ℝ.nn') ofSort: #'ℝ.nn'.
	realNumbers addOp: #'_-' withArgs: #(#'ℝ' #'ℝ') ofSort: #'ℝ'.
	realNumbers addOp: #'-' withArgs: #(#'ℝ') ofSort: #'ℝ'.
	realNumbers addOp: #'_×' withArgs: #(#'ℝ' #'ℝ') ofSort: #'ℝ'.
	realNumbers addOp: #'_×' withArgs: #(#'ℝ.p' #'ℝ.p') ofSort: #'ℝ.p'.
	realNumbers addOp: #'_×' withArgs: #(#'ℝ.nn' #'ℝ.nn') ofSort: #'ℝ.nn'.
	realNumbers addOp: #'_÷' withArgs: #(#'ℝ' #'ℝ.nz') ofSort: #'ℝ'.
	realNumbers addOp: #'_÷' withArgs: #(#'ℝ.nz' #'ℝ.nz') ofSort: #'ℝ.nz'.
	realNumbers addOp: #'_÷' withArgs: #(#'ℝ.p' #'ℝ.p') ofSort: #'ℝ.p'.
	realNumbers addOp: #'_÷' withArgs: #(#'ℝ.nn' #'ℝ.p') ofSort: #'ℝ.nn'.
	realNumbers addOp: #'^' withArgs: #(#'ℝ.p' #'ℝ.nz') ofSort: #'ℝ.p'.
	realNumbers addOp: #'^' withArgs: #(#'ℝ.nz' #'ℤ.nz') ofSort: #'ℝ.nz'.
	realNumbers addOp: #'^' withArgs: #(#'ℝ' #'ℕ.nz') ofSort: #'ℝ'.
	"Various functions"
	realNumbers addOp: #'abs' withArgs: #(#'ℝ') ofSort: #'ℝ.nn'.
	realNumbers addOp: #'abs' withArgs: #(#'ℝ.nz') ofSort: #'ℝ.p'.
	realNumbers addOp: #'√' withArgs: #(#'ℝ.nn') ofSort: #'ℝ.nn'.
	realNumbers addOp: #'√' withArgs: #(#'ℝ.p') ofSort: #'ℝ.p'.
	"Comparison operators"
	realNumbers addOp: #'_=' withArgs: #(#'ℝ' #'ℝ') ofSort: #boolean.
	realNumbers addOp: #'_<' withArgs: #(#'ℝ' #'ℝ') ofSort: #boolean.
	realNumbers addOp: #'_>' withArgs: #(#'ℝ' #'ℝ') ofSort: #boolean.
	realNumbers addOp: #'_≤' withArgs: #(#'ℝ' #'ℝ') ofSort: #boolean.
	realNumbers addOp: #'_≥' withArgs: #(#'ℝ' #'ℝ') ofSort: #boolean.
	"Build the context"
	realNumbers build.
]

{ #category : #initialization }
LeibnizBuiltins >> createStringContext [
	| string |
	string := self newContextBuilderNamed: 'strings'.
	string addSort: #string.
	string addOp: #'_+' withArgs: #(#string #string) ofSort: #string.
	string build.

]

{ #category : #initialization }
LeibnizBuiltins >> createTruthContext [
	| truth |
	truth := self newContextBuilderNamed: 'truth'.
	truth addSort: #boolean.
	truth addOp: #true ofSort: #boolean.
	truth addOp: #false ofSort: #boolean.
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

]
