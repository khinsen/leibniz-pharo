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
	context := builtins contextNamed: 'integers'.
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
	self assert: (context parseTermAndReduce: '4 div 3') equals: (context parseTerm: '1').
	self assert: (context parseTermAndReduce: '4 div 0') equals: (context parseTerm: '4 div 0').
	self assert: (context parseTermAndReduce: '0 rem 3') equals: (context parseTerm: '0').
	self assert: (context parseTermAndReduce: '0 rem 0') equals: (context parseTerm: '0 rem 0').
	self assert: (context parseTermAndReduce: '4 rem 3') equals: (context parseTerm: '1').
	self assert: (context parseTermAndReduce: '4 rem 0') equals: (context parseTerm: '4 rem 0').
	self assert: (context parseTermAndReduce: '0^{2}') equals: (context parseTerm: '0').
	self assert: (context parseTermAndReduce: '0^{0}') equals: (context parseTerm: '0^{0}').
	self assert: (context parseTermAndReduce: '3^{2}') equals: (context parseTerm: '9').
	self assert: (context parseTermAndReduce: '3^{-2}') equals: (context parseTerm: '3^{-2}').

	self assert: (context parseTermAndReduce: '3 < 2') equals: (context parseTerm: 'false').
	self assert: (context parseTermAndReduce: '3 > 2') equals: (context parseTerm: 'true').
	self assert: (context parseTermAndReduce: '2 ≤ 2') equals: (context parseTerm: 'true').
	self assert: (context parseTermAndReduce: '2 ≥ 2') equals: (context parseTerm: 'true').

"	self assert: (context parseTermAndReduce: '(2 + 3) ≥ (42-41)') equals: (context parseTerm: 'true').
"

]

{ #category : #testing }
LeibnizBuiltinsTest >> testIntegers [
	| context |
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
