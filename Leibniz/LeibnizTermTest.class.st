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
	p := LbTermParser signature: currentSignature.
	parse := [ :aString | p parse: aString onError: [ Error signal: 'failed to parse ', aString ] ].
	pattern := parse value: aPattern.
	term := parse value: aTerm.
	self assert: (pattern match: term) isNull.
]

{ #category : #running }
LeibnizTermTest >> check: aTerm matches: aPattern withSubstitution: aDictionary [
	| p parse pattern term substitutions |
	p := LbTermParser signature: currentSignature.
	parse := [ :aString | p parse: aString onError: [ Error signal: 'failed to parse ', aString ] ].
	pattern := parse value: aPattern.
	term := parse value: aTerm.
	substitutions := aDictionary collect: [ :each | parse value: each ].
	self assert: (pattern match: term) variables equals: substitutions.
]

{ #category : #running }
LeibnizTermTest >> checkSyntaxRoundTrip: aString [
	| p t |
	p := LbTermParser signature: currentSignature.
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
	t := LbContextTerm value: c signature: c signature.
	self assert: t sort equals: #context.

]

{ #category : #testing }
LeibnizTermTest >> testSyntax [
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
