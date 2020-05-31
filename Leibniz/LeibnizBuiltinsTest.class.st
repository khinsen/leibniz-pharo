Class {
	#name : #LeibnizBuiltinsTest,
	#superclass : #TestCase,
	#instVars : [
		'builtins'
	],
	#category : #'Leibniz-Tests'
}

{ #category : #running }
LeibnizBuiltinsTest >> setUp [
	builtins := LeibnizLibrary uniqueInstance builtins.

]

{ #category : #testing }
LeibnizBuiltinsTest >> testContexts [
	| context |
	context := builtins contextNamed: 'contexts'.
	self assert: context sortGraph size equals: 2.
	self assert: context sortGraph kinds size equals: 2.
	self assert: context signature numberOfOperators equals: 6.
	self assert: context signature numberOfVariables equals: 0.

]

{ #category : #testing }
LeibnizBuiltinsTest >> testFloats [
	| context |
	context := builtins contextNamed: 'IEEE-floating-point'.
	self assert: context sortGraph size equals: 18.
	self assert: context sortGraph kinds size equals: 3.
	self assert: context signature numberOfOperators equals: 16.
	self assert: context signature numberOfVariables equals: 0.

	self deny: (context signature hasBuiltin: #strings).
	self assert: (context signature hasBuiltin: #integers).
	self deny: (context signature hasBuiltin: #rationalNumbers).
	self assert: (context signature hasBuiltin: #fpNumbers).

]

{ #category : #testing }
LeibnizBuiltinsTest >> testIntegerArithmetic [
	| context |
	#('integers' 'rational-numbers' 'real-numbers') do:
		[ :name |
			context := builtins contextNamed: name.
			self assert: (context parseTermAndReduce: '2 + 0') equals: (context parseTerm: '2').
			self assert: (context parseTermAndReduce: '0 + 3') equals: (context parseTerm: '3').
			self assert: (context parseTermAndReduce: '2 + 3') equals: (context parseTerm: '5').
			self assert: (context parseTermAndReduce: '2 - 0') equals: (context parseTerm: '2').
			self assert: (context parseTermAndReduce: '2 - 3') equals: (context parseTerm: '-1').
			self assert: (context parseTermAndReduce: '-(2)') equals: (context parseTerm: '-2').
			self assert: (context parseTermAndReduce: '2 × 0') equals: (context parseTerm: '0').
			self assert: (context parseTermAndReduce: '2 × 1') equals: (context parseTerm: '2').
			self assert: (context parseTermAndReduce: '2 × 3') equals: (context parseTerm: '6').
			self assert: (context parseTermAndReduce: '1 × 3') equals: (context parseTerm: '3').
			self assert: (context parseTermAndReduce: '0 × 3') equals: (context parseTerm: '0').
			self assert: (context parseTermAndReduce: '0 div 3') equals: (context parseTerm: '0').
			self assert: (context parseTermAndReduce: '0 div 0') equals: (context parseTerm: '0 div 0').
			self assert: (context parseTermAndReduce: '17 div 5') equals: (context parseTerm: '3').
			self assert: (context parseTermAndReduce: '-17 div 5') equals: (context parseTerm: '-3').
			self assert: (context parseTermAndReduce: '17 div -5') equals: (context parseTerm: '-3').
			self assert: (context parseTermAndReduce: '-17 div -5') equals: (context parseTerm: '3').
			self assert: (context parseTermAndReduce: '17 div 0') equals: (context parseTerm: '17 div 0').
			self assert: (context parseTermAndReduce: '0 rem 3') equals: (context parseTerm: '0').
			self assert: (context parseTermAndReduce: '0 rem 0') equals: (context parseTerm: '0 rem 0').
			self assert: (context parseTermAndReduce: '17 rem 5') equals: (context parseTerm: '2').
			self assert: (context parseTermAndReduce: '-17 rem 5') equals: (context parseTerm: '-2').
			self assert: (context parseTermAndReduce: '17 rem -5') equals: (context parseTerm: '-2').
			self assert: (context parseTermAndReduce: '-17 rem -5') equals: (context parseTerm: '2').
			self assert: (context parseTermAndReduce: '17 rem 0') equals: (context parseTerm: '17 rem 0').
			self assert: (context parseTermAndReduce: '0^{2}') equals: (context parseTerm: '0').
			self assert: (context parseTermAndReduce: '0^{0}') equals: (context parseTerm: '0^{0}').
			self assert: (context parseTermAndReduce: '3^{2}') equals: (context parseTerm: '9').
			self assert: (context parseTermAndReduce: 'abs(2)') equals: (context parseTerm: '2').
			self assert: (context parseTermAndReduce: 'abs(-2)') equals: (context parseTerm: '2').

			self assert: (context parseTermAndReduce: '3 < 2') equals: (context parseTerm: 'false').
			self assert: (context parseTermAndReduce: '3 > 2') equals: (context parseTerm: 'true').
			self assert: (context parseTermAndReduce: '2 ≤ 2') equals: (context parseTerm: 'true').
			self assert: (context parseTermAndReduce: '2 ≥ 2') equals: (context parseTerm: 'true').

			self assert: (context parseTermAndReduce: '(2 + 3) ≥ (42 - 41)') equals: (context parseTerm: 'true').
			self assert: (context parseTermAndReduce: '(2 + 3) == (3 + 2)') equals: (context parseTerm: 'true') ].

	context := builtins contextNamed: #integers.
	self assert: (context parseTermAndReduce: '3^{-2}') equals: (context parseTerm: '3^{-2}').
]

{ #category : #testing }
LeibnizBuiltinsTest >> testIntegerArithmeticWithSymbolicValues [
	| b context |
	b := LeibnizContextBuilder name: 'test' document: LeibnizDocument new.
	b include: 'integers' fromDocumentWithHash: 'e513fb1f0504a951919688029321eaa02b4e2ad014c0979c4b602b946f9cafc8' inMode: 'extend'.
	b parseAndAddOp: 'a : ℤ'.
	b parseAndAddOp: 'b : ℤ'.
	context := b context.
	self assert: (context parseTermAndReduce: 'a + 0') equals: (context parseTerm: 'a').
	self assert: (context parseTermAndReduce: 'a - 0') equals: (context parseTerm: 'a').
	self assert: (context parseTermAndReduce: '0 + b') equals: (context parseTerm: 'b').
	self assert: (context parseTermAndReduce: '0 - b') equals: (context parseTerm: '-(b)').

]

{ #category : #testing }
LeibnizBuiltinsTest >> testIntegers [
	| context |
	context := builtins contextNamed: 'integers-without-rules'.
	self assert: context sortGraph size equals: 6.
	self assert: context sortGraph kinds size equals: 2.
	self assert: context signature numberOfOperators equals: 14.
	self assert: context signature numberOfVariables equals: 0.

	self deny: (context signature hasBuiltin: #strings).
	self assert: (context signature hasBuiltin: #integers).
	self deny: (context signature hasBuiltin: #rationalNumbers).
	self deny: (context signature hasBuiltin: #fpNumbers).

	context := builtins contextNamed: 'integers'.
	self assert: context sortGraph size equals: 6.
	self assert: context sortGraph kinds size equals: 2.
	self assert: context signature numberOfOperators equals: 14.
	self assert: context signature numberOfVariables equals: 0.

	self deny: (context signature hasBuiltin: #strings).
	self assert: (context signature hasBuiltin: #integers).
	self deny: (context signature hasBuiltin: #rationalNumbers).
	self deny: (context signature hasBuiltin: #fpNumbers).

]

{ #category : #testing }
LeibnizBuiltinsTest >> testRationalNumberArithmetic [
	| context |
	#('rational-numbers' 'real-numbers') do:
		[ :name |
			context := builtins contextNamed: name.
			self assert: (context parseTermAndReduce: '1/2 + 0') equals: (context parseTerm: '1/2').
			self assert: (context parseTermAndReduce: '0 + 1/3') equals: (context parseTerm: '1/3').
			self assert: (context parseTermAndReduce: '2/3 + 1/3') equals: (context parseTerm: '1').
			self assert: (context parseTermAndReduce: '1/2 - 0') equals: (context parseTerm: '1/2').
			self assert: (context parseTermAndReduce: '1/2 - 3/2') equals: (context parseTerm: '-1').
			self assert: (context parseTermAndReduce: '-(1/2)') equals: (context parseTerm: '-1/2').
			self assert: (context parseTermAndReduce: '1/2 × 0') equals: (context parseTerm: '0').
			self assert: (context parseTermAndReduce: '1/2 × 1') equals: (context parseTerm: '1/2').
			self assert: (context parseTermAndReduce: '1/2 × 1/3') equals: (context parseTerm: '1/6').
			self assert: (context parseTermAndReduce: '1 × 1/3') equals: (context parseTerm: '1/3').
			self assert: (context parseTermAndReduce: '0 × 1/3') equals: (context parseTerm: '0').
			self assert: (context parseTermAndReduce: '0 ÷ 3') equals: (context parseTerm: '0').
			self assert: (context parseTermAndReduce: '0 ÷ 1/3') equals: (context parseTerm: '0').
			self assert: (context parseTermAndReduce: '0 ÷ 0') equals: (context parseTerm: '0 ÷ 0').
			self assert: (context parseTermAndReduce: '17 ÷ 5') equals: (context parseTerm: '17/5').
			self assert: (context parseTermAndReduce: '1 ÷ 1/3') equals: (context parseTerm: '3').
			self assert: (context parseTermAndReduce: '0^{2}') equals: (context parseTerm: '0').
			self assert: (context parseTermAndReduce: '0^{0}') equals: (context parseTerm: '0^{0}').
			self assert: (context parseTermAndReduce: '0^{-2}') equals: (context parseTerm: '0^{-2}').
			self assert: (context parseTermAndReduce: '3^{2}') equals: (context parseTerm: '9').
			self assert: (context parseTermAndReduce: '3^{-2}') equals: (context parseTerm: '1/9').
			self assert: (context parseTermAndReduce: '1/3^{-2}') equals: (context parseTerm: '9').
			self assert: (context parseTermAndReduce: 'abs(2/3)') equals: (context parseTerm: '2/3').
			self assert: (context parseTermAndReduce: 'abs(-2/3)') equals: (context parseTerm: '2/3').

			self assert: (context parseTermAndReduce: '3/5 < 2/5') equals: (context parseTerm: 'false').
			self assert: (context parseTermAndReduce: '3/5 > 2/5') equals: (context parseTerm: 'true').
			self assert: (context parseTermAndReduce: '2/5 ≤ 2/5') equals: (context parseTerm: 'true').
			self assert: (context parseTermAndReduce: '2/5 ≥ 2/5') equals: (context parseTerm: 'true').
			self assert: (context parseTermAndReduce: '(2/5 + 4/5) ≥ 1/5') equals: (context parseTerm: 'true').
			self assert: (context parseTermAndReduce: '(2/3 + 1) == (1 + 2/3)') equals: (context parseTerm: 'true') ].
]

{ #category : #testing }
LeibnizBuiltinsTest >> testRationalNumbers [
	| context |
	context := builtins contextNamed: 'rational-numbers'.
	self assert: context sortGraph size equals: 10.
	self assert: context sortGraph kinds size equals: 2.
	self assert: context signature numberOfOperators equals: 15.
	self assert: context signature numberOfVariables equals: 0.

	self deny: (context signature hasBuiltin: #strings).
	self assert: (context signature hasBuiltin: #integers).
	self assert: (context signature hasBuiltin: #rationalNumbers).
	self deny: (context signature hasBuiltin: #fpNumbers).

]

{ #category : #testing }
LeibnizBuiltinsTest >> testRealNumbers [
	| context |
	context := builtins contextNamed: 'real-numbers'.
	self assert: context sortGraph size equals: 14.
	self assert: context sortGraph kinds size equals: 2.
	self assert: context signature numberOfOperators equals: 16.
	self assert: context signature numberOfVariables equals: 0.

	self deny: (context signature hasBuiltin: #strings).
	self assert: (context signature hasBuiltin: #integers).
	self assert: (context signature hasBuiltin: #rationalNumbers).
	self deny: (context signature hasBuiltin: #fpNumbers).

]

{ #category : #testing }
LeibnizBuiltinsTest >> testStrings [
	| context |
	context := builtins contextNamed: 'strings'.

	self assert: context sortGraph size equals: 1.
	self assert: context sortGraph kinds size equals: 1.
	self assert: context signature numberOfOperators equals: 1.
	self assert: context signature numberOfVariables equals: 0.
	self assert: (context signature hasBuiltin: #strings).
	self deny: (context signature hasBuiltin: #integers).
	self deny: (context signature hasBuiltin: #rationalNumbers).
	self deny: (context signature hasBuiltin: #fpNumbers).

]

{ #category : #testing }
LeibnizBuiltinsTest >> testTruth [
	| context |
	context := builtins contextNamed: 'truth'.

	self assert: context sortGraph size equals: 1.
	self assert: context sortGraph kinds size equals: 1.
	self assert: context signature numberOfOperators equals: 2.
	self assert: context signature numberOfVariables equals: 0.

	self deny: (context signature hasBuiltin: #strings).
	self deny: (context signature hasBuiltin: #integers).
	self deny: (context signature hasBuiltin: #rationalNumbers).
	self deny: (context signature hasBuiltin: #fpNumbers).

]
