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
	builtins := LeibnizBuiltins uniqueInstance.

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
	self assert: context signature numberOfOperators equals: 17.
	self assert: context signature numberOfVariables equals: 0.

]

{ #category : #testing }
LeibnizBuiltinsTest >> testIntegers [
	| context |
	context := builtins contextNamed: 'integers'.
	self assert: context sortGraph size equals: 6.
	self assert: context sortGraph kinds size equals: 2.
	self assert: context signature numberOfOperators equals: 15.
	self assert: context signature numberOfVariables equals: 0.

]

{ #category : #testing }
LeibnizBuiltinsTest >> testRationalNumbers [
	| context |
	context := builtins contextNamed: 'rational-numbers'.
	self assert: context sortGraph size equals: 10.
	self assert: context sortGraph kinds size equals: 2.
	self assert: context signature numberOfOperators equals: 16.
	self assert: context signature numberOfVariables equals: 0.

]

{ #category : #testing }
LeibnizBuiltinsTest >> testRealNumbers [
	| context |
	context := builtins contextNamed: 'real-numbers'.
	self assert: context sortGraph size equals: 14.
	self assert: context sortGraph kinds size equals: 2.
	self assert: context signature numberOfOperators equals: 17.
	self assert: context signature numberOfVariables equals: 0.

]

{ #category : #testing }
LeibnizBuiltinsTest >> testStrings [
	| context |
	context := builtins contextNamed: 'strings'.

	self assert: context sortGraph size equals: 1.
	self assert: context sortGraph kinds size equals: 1.
	self assert: context signature numberOfOperators equals: 1.
	self assert: context signature numberOfVariables equals: 0.

]

{ #category : #testing }
LeibnizBuiltinsTest >> testTruth [
	| context |
	context := builtins contextNamed: 'truth'.

	self assert: context sortGraph size equals: 1.
	self assert: context sortGraph kinds size equals: 1.
	self assert: context signature numberOfOperators equals: 2.
	self assert: context signature numberOfVariables equals: 0.

]
