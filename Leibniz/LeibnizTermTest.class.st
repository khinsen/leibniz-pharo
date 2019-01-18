Class {
	#name : #LeibnizTermTest,
	#superclass : #TestCase,
	#instVars : [
		'library',
		'builtins'
	],
	#category : #'Leibniz-Tests'
}

{ #category : #running }
LeibnizTermTest >> setUp [
	library := LeibnizLibrary uniqueInstance.
	builtins := library builtins.
]

{ #category : #testing }
LeibnizTermTest >> testFPNumbers [
	| c t |
	c := builtins contextNamed: 'IEEE-floating-point'.
	t := [ :x | LeibnizFPNumberTerm value: x inContext: c ].
	self assert: (t value: 0.0) sort equals: #'FP64-number'.
	self assert: (t value: 2.0) sort equals: #'FP64-number'.
	self assert: (t value: -2.0) sort equals: #'FP64-number'.
	self assert: (t value: Float nan) sort equals: #'FP64-NaN'.
	self assert: (t value: Float infinity) sort equals: #'FP64-inf'.
	self assert: (t value: Float negativeInfinity) sort equals: #'FP64-inf'.

]

{ #category : #testing }
LeibnizTermTest >> testIntegers [
	| c t |
	c := builtins contextNamed: 'integers'.
	t := [ :x | LeibnizIntegerTerm value: x inContext: c ].
	self assert: (t value: 2) sort equals: #'ℕ.nz'.
	self assert: (t value: -2) sort equals: #'ℤ.nz'.
	self assert: (t value: 0) sort equals: #zero.

]

{ #category : #testing }
LeibnizTermTest >> testRationalNumbers [
	| c t |
	c := builtins contextNamed: 'rational-numbers'.
	t := [ :x | LeibnizRationalNumberTerm value: x inContext: c ].
	self assert: (t value: 0) sort equals: #zero.
	self assert: (t value: 2) sort equals: #'ℕ.nz'.
	self assert: (t value: -2) sort equals: #'ℤ.nz'.
	self assert: (t value: 2/3) sort equals: #'ℚ.p'.
	self assert: (t value: -2/3) sort equals: #'ℚ.nz'.

]

{ #category : #testing }
LeibnizTermTest >> testStrings [
	| c t |
	c := builtins contextNamed: 'strings'.
	t := LeibnizStringTerm value: 'abc' inContext: c.
	self assert: t sort equals: #string.

]
