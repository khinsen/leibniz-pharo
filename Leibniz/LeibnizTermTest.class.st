Class {
	#name : #LeibnizTermTest,
	#superclass : #TestCase,
	#instVars : [
		'library',
		'builtins',
		'examples'
	],
	#category : #'Leibniz-Tests'
}

{ #category : #running }
LeibnizTermTest >> check: aTerm doesNotMatch: aPattern withSignature: aSignature [
	| p parse pattern term |
	p := LeibnizTermConstructor new.
	p setSignature: aSignature.
	parse := [ :aString | p parse: aString onError: [ Error signal: 'failed to parse ', aString ] ].
	pattern := parse value: aPattern.
	term := parse value: aTerm.
	self assert: (pattern match: term) equals: nil.

]

{ #category : #running }
LeibnizTermTest >> check: aTerm matches: aPattern withSubstitution: aDictionary inSignature: aSignature [
	| p parse pattern term substitutions |
	p := LeibnizTermConstructor new.
	p setSignature: aSignature.
	parse := [ :aString | p parse: aString onError: [ Error signal: 'failed to parse ', aString ] ].
	pattern := parse value: aPattern.
	term := parse value: aTerm.
	substitutions := aDictionary collect: [ :each | parse value: each ].
	self assert: (pattern match: term) variables equals: substitutions.

]

{ #category : #running }
LeibnizTermTest >> checkSyntaxRoundTrip: aString withSignature: aSignature [
	| p t |
	p := LeibnizTermConstructor new.
	p setSignature: aSignature.
	t := p parse: aString onError: [ Error signal: 'failed to parse ', aString ].
	self assert: t asLeibnizSyntaxString equals: aString.

]

{ #category : #running }
LeibnizTermTest >> setUp [
	library := LeibnizLibrary uniqueInstance.
	builtins := library builtins.
	examples := LeibnizExamples new.
]

{ #category : #testing }
LeibnizTermTest >> testContexts [
	| c t |
	c := builtins contextNamed: 'contexts'.
	t := LeibnizContextTerm value: c forSignature: c signature.
	self assert: t sort equals: #context.

]

{ #category : #testing }
LeibnizTermTest >> testFPNumbers [
	| c t |
	c := builtins contextNamed: 'IEEE-floating-point'.
	t := [ :x | LeibnizFPNumberTerm value: x forSignature: c signature ].
	self assert: (t value: 0.0) sort equals: #'FP64-number'.
	self assert: (t value: 2.0) sort equals: #'FP64-number'.
	self assert: (t value: -2.0) sort equals: #'FP64-number'.
	self assert: (t value: Float nan) sort equals: #'FP64-NaN'.
	self assert: (t value: Float infinity) sort equals: #'FP64-inf'.
	self assert: (t value: Float negativeInfinity) sort equals: #'FP64-inf'.

]

{ #category : #testing }
LeibnizTermTest >> testIntegers [
	| c i t |
	c := builtins contextNamed: 'integers'.
	i := [ :x | LeibnizIntegerTerm value: x forSignature: c signature ].

	self assert: (i value: 2) sort equals: #'ℕ.nz'.
	self assert: (i value: -2) sort equals: #'ℤ.nz'.
	self assert: (i value: 0) sort equals: #zero.

	t := c signature nonZeroArgTermNamed: #abs withArgs: { (i value: 2) }.
	self assert: t sort equals: #'ℕ.nz'.
	t := c signature nonZeroArgTermNamed: #abs withArgs: { (i value: 0) }.
	self assert: t sort equals: #'ℕ'.
	t := c signature nonZeroArgTermNamed: #'_+' withArgs: { (i value: 0) . (i value: 2)}.
	self assert: t sort equals: #'ℕ.nz'.
	t := c signature nonZeroArgTermNamed: #'_+' withArgs: { (i value: -2) . (i value: 2)}.
	self assert: t sort equals: #'ℤ'.
]

{ #category : #testing }
LeibnizTermTest >> testMatching [
	| c |
	c := examples contextNamed: 'boolean'.

	self check: 'true' matches: 'X'
		  withSubstitution: (Dictionary with: #X -> 'true')
		  inSignature: c signature.
	self check: '¬(true)' matches: '¬(X)'
		  withSubstitution: (Dictionary with: #X -> 'true')
		  inSignature: c signature.
	self check: '¬(true)' matches: 'X'
		  withSubstitution: (Dictionary with: #X -> '¬(true)')
		  inSignature: c signature.
	self check: 'true ⊻ false ⊻ true ⊻ ¬(true)' matches: 'true ⊻ false ⊻ X ⊻ Y'
		  withSubstitution: (Dictionary with: #X -> 'true' with: #Y -> '¬(true)')
		  inSignature: c signature.
	self check: 'true ⊻ true' matches: 'X ⊻ X'
		  withSubstitution: (Dictionary with: #X -> 'true')
		  inSignature: c signature.

	self check: 'true' doesNotMatch: 'false' withSignature: c signature.
	self check: 'true ⊻ false' doesNotMatch: 'X ⊻ X' withSignature: c signature.

]

{ #category : #testing }
LeibnizTermTest >> testRationalNumbers [
	| c t |
	c := builtins contextNamed: 'rational-numbers'.
	t := [ :x | LeibnizRationalNumberTerm value: x forSignature: c signature ].
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
	t := LeibnizStringTerm value: 'abc' forSignature: c signature.
	self assert: t sort equals: #string.

]

{ #category : #testing }
LeibnizTermTest >> testSyntax [
	| c |
	c := builtins contextNamed: 'truth'.
	self checkSyntaxRoundTrip: 'true' withSignature: c signature.
	self checkSyntaxRoundTrip: 'false' withSignature: c signature.

	c := builtins contextNamed: 'integers'.
	self checkSyntaxRoundTrip: '2' withSignature: c signature.
	self checkSyntaxRoundTrip: 'abs(-2)' withSignature: c signature.
	self checkSyntaxRoundTrip: '2 + 3 + 4 + 5' withSignature: c signature.
	self checkSyntaxRoundTrip: '(2 + 3) × (2 - 7)' withSignature: c signature.
	self checkSyntaxRoundTrip: '(3 - -4) div (-2 × 1)' withSignature: c signature.
	self checkSyntaxRoundTrip: '(2 + 3 + 4) rem 5' withSignature: c signature.
	self checkSyntaxRoundTrip: '2^{3}' withSignature: c signature.
	self checkSyntaxRoundTrip: '2^{2^{3}}' withSignature: c signature.
	self checkSyntaxRoundTrip: '(2 - 4)^{3}' withSignature: c signature.

	c := builtins contextNamed: 'rational-numbers'.
	self checkSyntaxRoundTrip: '2/3' withSignature: c signature.
	self checkSyntaxRoundTrip: 'abs(-2/3)' withSignature: c signature.
	self checkSyntaxRoundTrip: '2/3^{3}' withSignature: c signature.
	self checkSyntaxRoundTrip: '2/3 + 3/4 + 1/7' withSignature: c signature.
	self checkSyntaxRoundTrip: '(2/3 + 3/4 + 1/7) ÷ -3/4' withSignature: c signature.
	self checkSyntaxRoundTrip: '1/7 < 3/4' withSignature: c signature.

	c := builtins contextNamed: 'IEEE-floating-point'.
	self checkSyntaxRoundTrip: '2.5' withSignature: c signature.
	self checkSyntaxRoundTrip: 'abs(-2.5)' withSignature: c signature.
	self checkSyntaxRoundTrip: '√(2.5)' withSignature: c signature.
	self checkSyntaxRoundTrip: '2.3 + 3.4' withSignature: c signature.
	self checkSyntaxRoundTrip: '2.3^{3.2}' withSignature: c signature.

	c := examples contextNamed: 'boolean'.
	self checkSyntaxRoundTrip: 'true' withSignature: c signature.
	self checkSyntaxRoundTrip: '¬(false)' withSignature: c signature.
	self checkSyntaxRoundTrip: 'X ⊻ Y ⊻ (X ∧ Y)' withSignature: c signature.
	self checkSyntaxRoundTrip: 'true ⊻ false ⊻ X ⊻ Y' withSignature: c signature.

	c := examples contextNamed: 'ℝ→ℝ'.
	self checkSyntaxRoundTrip: '(f + g)[X]' withSignature: c signature.
	self checkSyntaxRoundTrip: 'f[X] + g[X]' withSignature: c signature.
	self checkSyntaxRoundTrip: '(s × g)[X]' withSignature: c signature.
	self checkSyntaxRoundTrip: 's × g[X]' withSignature: c signature.
	self checkSyntaxRoundTrip: 'f[g[X]]' withSignature: c signature.

]

{ #category : #testing }
LeibnizTermTest >> testTruth [
	| c t |
	c := builtins contextNamed: 'truth'.
	t := c signature zeroArgTermNamed: #true.
	self assert: t sort equals: #boolean.
	t := c signature zeroArgTermNamed: #false.
	self assert: t sort equals: #boolean.

]
