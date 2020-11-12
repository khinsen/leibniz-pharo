Class {
	#name : #LeibnizTermTest,
	#superclass : #TestCase,
	#instVars : [
		'library',
		'builtins',
		'examples',
		'currentSignature'
	],
	#category : #'Leibniz-3-Terms'
}

{ #category : #running }
LeibnizTermTest >> check: aTerm doesNotMatch: aPattern [
	| p parse pattern term |
	p := LbTermParser forSignature: currentSignature.
	parse := [ :aString | p parse: aString onError: [ Error signal: 'failed to parse ', aString ] ].
	pattern := parse value: aPattern.
	term := parse value: aTerm.
	self assert: (pattern match: term) equals: nil.

]

{ #category : #running }
LeibnizTermTest >> check: aTerm matches: aPattern withSubstitution: aDictionary [
	| p parse pattern term substitutions |
	p := LbTermParser forSignature: currentSignature.
	parse := [ :aString | p parse: aString onError: [ Error signal: 'failed to parse ', aString ] ].
	pattern := parse value: aPattern.
	term := parse value: aTerm.
	substitutions := aDictionary collect: [ :each | parse value: each ].
	self assert: (pattern match: term) variables equals: substitutions.

]

{ #category : #running }
LeibnizTermTest >> check: aPattern withSubstitution: aDictionary equals: aTerm [
	| p parse pattern term substitution result |
	p := LbTermParser forSignature: currentSignature.
	parse := [ :aString | p parse: aString onError: [ Error signal: 'failed to parse ', aString ] ].
	pattern := parse value: aPattern.
	term := parse value: aTerm.
	substitution := LbSubstitution new.
	aDictionary keysAndValuesDo:
		[ :name :value | substitution combineWith:
									(LbSubstitution variable: name
																value: (parse value: value)) ].
	result := pattern substitute: substitution.
	self assert: result equals: term.

]

{ #category : #running }
LeibnizTermTest >> checkSyntaxRoundTrip: aString [
	| p t |
	p := LbTermParser forSignature: currentSignature.
	t := p parse: aString onError: [ Error signal: 'failed to parse ', aString ].
	self assert: t asLeibnizSyntaxString equals: aString.

]

{ #category : #running }
LeibnizTermTest >> setUp [
"	library := LeibnizLibrary uniqueInstance.
	builtins := library builtins.
	examples := LeibnizExamples new."
]

{ #category : #testing }
LeibnizTermTest >> testContexts [
	| c t |
	c := builtins contextNamed: 'contexts'.
	t := LbContextTerm value: c forSignature: c signature.
	self assert: t sort equals: #context.

]

{ #category : #testing }
LeibnizTermTest >> testMatching [
	self useContext: (examples contextNamed: 'boolean').

	self check: 'true' matches: 'X'
		  withSubstitution: (Dictionary with: #X -> 'true').
	self check: '¬(true)' matches: '¬(X)'
		  withSubstitution: (Dictionary with: #X -> 'true').
	self check: '¬(true)' matches: 'X'
		  withSubstitution: (Dictionary with: #X -> '¬(true)').
	self check: 'true ⊻ false ⊻ true ⊻ ¬(true)' matches: 'true ⊻ false ⊻ X ⊻ Y'
		  withSubstitution: (Dictionary with: #X -> 'true' with: #Y -> '¬(true)').
	self check: 'true ⊻ true' matches: 'X ⊻ X'
		  withSubstitution: (Dictionary with: #X -> 'true').

	self check: 'true' doesNotMatch: 'false'.
	self check: 'true ⊻ false' doesNotMatch: 'X ⊻ X'.

]

{ #category : #testing }
LeibnizTermTest >> testSubstitutions [
	self useContext: (examples contextNamed: 'boolean').

	self check: 'true'
		  withSubstitution: (Dictionary new)
		  equals: 'true'.
	self check: 'X'
		  withSubstitution: (Dictionary with: #X -> 'true')
		  equals: 'true'.
	self check: '¬(X)'
		  withSubstitution: (Dictionary with: #X -> 'true')
		  equals: '¬(true)'.
	self check: 'X ⊻ X'
		  withSubstitution: (Dictionary with: #X -> 'true')
		  equals: 'true ⊻ true'.
	self check: 'X ⊻ Y'
		  withSubstitution: (Dictionary with: #X -> 'true')
		  equals: 'true ⊻ Y'.
	self check: 'X ⊻ Y'
		  withSubstitution: (Dictionary with: #X -> 'true' with: #Y -> 'false')
		  equals: 'true ⊻ false'.

]

{ #category : #testing }
LeibnizTermTest >> testSyntax [
	self useContext: (examples contextNamed: 'boolean').
	self checkSyntaxRoundTrip: 'true'.
	self checkSyntaxRoundTrip: '¬(false)'.
	self checkSyntaxRoundTrip: 'X ⊻ Y ⊻ (X ∧ Y)'.
	self checkSyntaxRoundTrip: 'true ⊻ false ⊻ X ⊻ Y'.

	self useContext: (examples contextNamed: 'ℝ→ℝ').
	self checkSyntaxRoundTrip: '(f + g)[X]'.
	self checkSyntaxRoundTrip: 'f[X] + g[X]'.
	self checkSyntaxRoundTrip: '(s × g)[X]'.
	self checkSyntaxRoundTrip: 's × g[X]'.
	self checkSyntaxRoundTrip: 'f[g[X]]'.

]

{ #category : #testing }
LeibnizTermTest >> useContext: aContext [
	currentSignature := aContext signature
]
