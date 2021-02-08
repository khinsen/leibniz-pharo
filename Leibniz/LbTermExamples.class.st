Class {
	#name : #LbTermExamples,
	#superclass : #Object,
	#traits : 'TGtExampleAssertable',
	#classTraits : 'TGtExampleAssertable classTrait',
	#category : #'Leibniz-3-Terms'
}

{ #category : #example }
LbTermExamples >> booleanTerms [
	<gtExample>
	| trueTerm falseTerm |
	trueTerm := LbBuiltinSignatures truthSignature zeroArgTermNamed: (LbPrefixOperatorName for: #true).
	self assert: trueTerm sort name equals: #boolean.
	self assert: trueTerm isTrue.
	self assert: trueTerm headOpName asSymbol equals: #true.
	falseTerm := LbBuiltinSignatures truthSignature zeroArgTermNamed: (LbPrefixOperatorName for: #false).
	self assert: falseTerm sort name equals: #boolean.
	self assert:falseTerm isTrue not.
	self assert: falseTerm headOpName asSymbol equals: #false.
	^ { trueTerm. falseTerm }
]

{ #category : #example }
LbTermExamples >> booleanUnifications [
	<gtExample>
	| s |
	s := LbSignatureExamples new booleanSignature.
	^ {
		{'true'. 'X'. '(X=true)'}.
		{'¬(X)'. '¬(true)'. '(X=true)'}.
		{'X'. '¬(true)'. '(X=¬(true))'}.
		{'true ⊻ false ⊻ true ⊻ ¬(true)'. 'true ⊻ false ⊻ X ⊻ Y'. '(X=true, Y=¬(true))'}.
		{'false ⊻ X ⊻ true ⊻ ¬(true)'. 'false ⊻ true ⊻ X ⊻ Y'. '(X=true, Y=¬(true))'}.
		{'X ⊻ ¬(X)'. 'false ⊻ ¬(X)'. '(X=false)'}.
		{'X ⊻ ¬(Y)'. 'false ⊻ ¬(Y)'. '(Y, X=false)'}.
		{'true'. 'false'.  '(failure #nonEqualTerms: false, true)' }.
	} collect: [ :each |
		| unification string |
		unification := (s parseTerm: each first) unify: (s parseTerm: each  second).
		string := unification printString.
		self assert: (string allButFirst: (string findString: '(') - 1) equals: each third.
		unification ]
]

{ #category : #private }
LbTermExamples >> check: aTerm matches: aPattern withSubstitution: aDictionaryOrNil signature: aSignature [
	| p parse pattern term variables substitution |
	p := LbTermParser signature: aSignature.
	parse := [ :aString |
		p parse: aString onError: [ Error signal: 'failed to parse ', aString ] ].
	pattern := parse value: aPattern.
	term := parse value: aTerm.
	substitution := pattern match: term.
	aDictionaryOrNil
		ifNil: [ self assert: substitution isFailure ]
		ifNotNil: [
			variables := Dictionary
				newFromKeys: (aDictionaryOrNil keys collect: [ :each |
								LbPrefixOperatorName for: each])
				andValues: (aDictionaryOrNil values collect:[ :each |
								parse value: each ]).
			self assert: substitution bindings equals: variables ].
	^ substitution
]

{ #category : #private }
LbTermExamples >> check: aPattern withSubstitution: aDictionary equals: aTerm signature: aSignature [
	| p parse pattern term substitution result |
	p := LbTermParser signature: aSignature.
	parse := [ :aString |
		p parse: aString onError: [ Error signal: 'failed to parse ', aString ] ].
	pattern := parse value: aPattern.
	term := parse value: aTerm.
	substitution := LbVariables new.
	aDictionary keysAndValuesDo: [ :name :value |
		| parsedValue varName |
		parsedValue := parse value: value.
		varName := LbPrefixOperatorName for: name.
		substitution
			defineVar: varName
			ofSort: parsedValue sort.
		substitution
			bindVar: varName
			ofSort: parsedValue sort
			to: parsedValue ].
	result := pattern substitute: substitution.
	self assert: result equals: term.
	^ result
]

{ #category : #private }
LbTermExamples >> checkSyntaxRoundTrip: aString signature: aSignature [
	| term |
	term := (LbTermParser signature: aSignature)
				parse: aString.
	self assert: term asLeibnizSyntaxString equals: aString.
	^ term
]

{ #category : #example }
LbTermExamples >> fpNumberLiteralTerms [
	<gtExample>
	| inputs |
	inputs := {
		0.0 -> #'FP64.number'.
		2.0 -> #'FP64.number'.
		-2.0 -> #'FP64.number'.
		Float nan -> #'FP64.NaN'.
		Float infinity -> #'FP64.inf'.
		Float negativeInfinity -> #'FP64.inf'.
	}.
	^ inputs collect: [ :each |
		| t |
		t := LbBuiltinSignatures fpNumberSignature atomicTerm: each key.
		self assert: t sort name equals: each value.
		self assert: t headOpName asSymbol equals: #Atomic.
		t ]
]

{ #category : #example }
LbTermExamples >> integerLiteralTerms [
	<gtExample>
	| inputs |
	inputs := {
		2 -> #'ℕ.nz'.
		0 -> #zero.
		-2 -> #'ℤ.nz'.
	}.
	^ inputs collect: [ :each |
		| t |
		t := LbBuiltinSignatures integerSignature atomicTerm: each key.
		self assert: t sort name equals: each value.
		self assert: t headOpName asSymbol equals: #Atomic.
		t ]
]

{ #category : #example }
LbTermExamples >> integerTerms [
	<gtExample>
	| signature literals |
	signature := LbBuiltinSignatures integerSignature.
	literals := self integerLiteralTerms.
	^ {
		{ LbPrefixOperatorName for: #abs.
		 	literals first }
		 	-> #'ℕ.nz'.
		{ LbPrefixOperatorName for: #abs.
		 	literals second }
		 	-> #'ℕ'.
		{ LbInfixOperatorName for: #+.
		 	literals first. literals third. }
		 	-> #'ℤ'.
		{ LbInfixOperatorName for: #+.
		 	literals second. literals first. }
		 	-> #'ℕ.nz'.
	} collect: [ :each |
		| term |
		term := signature
					nonZeroArgTermNamed: each key first
					withArgs: each key allButFirst.
		self assert: term sort name equals: each value.
		term ]
]

{ #category : #example }
LbTermExamples >> matches [
	<gtExample>
	| s |
	s := LbSignatureExamples new booleanSignature.
	self should: [
		self
			check: 'X ⊻ X' matches: 'true ⊻ true'
			withSubstitution: (Dictionary with: #X -> 'true')
			signature: s ]
	raise: Error.
	^ {
	self
		check: 'true' matches: 'X'
		withSubstitution: (Dictionary with: #X -> 'true')
		signature: s.
	self
		check: '¬(true)' matches: '¬(X)'
		withSubstitution: (Dictionary with: #X -> 'true')
		signature: s.
	self
		check: '¬(true)' matches: 'X'
		withSubstitution: (Dictionary with: #X -> '¬(true)')
		signature: s.
	self
		check: 'true ⊻ false ⊻ true ⊻ ¬(true)' matches: 'true ⊻ false ⊻ X ⊻ Y'
		withSubstitution: (Dictionary with: #X -> 'true' with: #Y -> '¬(true)')
		signature: s.
	self
		check: 'true ⊻ true' matches: 'X ⊻ X'
		withSubstitution: (Dictionary with: #X -> 'true')
		signature: s.
	self
		check: 'true' matches: 'false'
		withSubstitution: nil
		signature: s.
	self
		check: 'true ⊻ false' matches: 'X ⊻ X'
		withSubstitution: nil
		signature: s.
	}
]

{ #category : #accessing }
LbTermExamples >> namespacedUnifications [
	<gtExample>
	| rns s unifications unification nameX nameY nameV nameW leftZ rightZ |
	rns := LbBuiltinSignatures integerSignature.
	s := (LbSignatureBuilder sortGraph: rns sortGraph)
			addSignature: rns includeVars: false;
			parseAndAddVar: 'V:ℤ';
			parseAndAddVar: 'W:ℤ';
			parseAndAddVar: 'X:ℤ';
			parseAndAddVar: 'Y:ℤ';
			parseAndAddVar: 'Z:ℤ';
			signature.
	nameV := #'left.V' asLbOperatorName.
	nameW := #'left.W' asLbOperatorName.
	nameX := #'right.X' asLbOperatorName.
	nameY := #'right.Y' asLbOperatorName.
	leftZ := #'left.Z' asLbOperatorName.
	rightZ := #'right.Z' asLbOperatorName.
	unifications := OrderedCollection new.

	unification := (s parseTerm: 'V + W')
		 unify: (s parseTerm: 'X + Y + Z')
		 leftVarPrefix: #left rightVarPrefix: #right.
	self
		assert: (unification varsInNamespace: #left)
		equals: (Set with: nameV with: nameW).
	self
		assert: (unification varsInNamespace: #right)
		equals: (Set with: nameX with: nameY with: rightZ).
	unifications add: unification.

	unification := (s parseTerm: 'Z + V')
		 unify: (s parseTerm: 'Z + Y')
		 leftVarPrefix: #left rightVarPrefix: #right.
	self
		assert: (unification varsInNamespace: #left)
		equals: (Set with: leftZ with: nameV).
	self
		assert: (unification varsInNamespace: #right)
		equals: (Set with: rightZ with: nameY).
	unifications add: unification.

	unification := (s parseTerm: 'V + W')
		 unify: (s parseTerm: 'Z + 2 + Z')
		 leftVarPrefix: #left rightVarPrefix: #right.
	self
		assert: (unification varsInNamespace: #left)
		equals: (Set with: nameV with: nameW).
	self
		assert: (unification varsInNamespace: #right)
		equals: (Set with: rightZ).
	unifications add: unification.

	^ unifications
]

{ #category : #example }
LbTermExamples >> numberUnifications [
	<gtExample>
	| rns s |
	rns := LbBuiltinSignatures realNumberSignature.
	s := (LbSignatureBuilder sortGraph: rns sortGraph)
			addSignature: rns includeVars: false;
			parseAndAddVar: 'anInteger:ℤ';
			parseAndAddVar: 'aPositiveRational:ℚ.p';
			parseAndAddVar: 'aBoolean:boolean';
			signature.
	^ {
		{'anInteger'. '42'. '(anInteger=42)'}.
		{'anInteger'. '-42'. '(anInteger=-42)'}.
		{'aPositiveRational'. '42'. '(aPositiveRational=42)'}.
		{'aPositiveRational'. '-42'.  '(failure #notSubsort: ℤ.nz, ℚ.p)' }.
		{'aBoolean'. '42'. '(failure #notSubsort: ℕ.nz, boolean)'}.
		{'anInteger'. 'aPositiveRational'. '(failure #incommensurableSorts: ℚ.p, ℤ)'}.
		{'anInteger'. 'aBoolean'. '(failure #incommensurableSorts: boolean, ℤ)'}.
	} collect: [ :each |
		| unification string |
		unification := (s parseTerm: each first) unify: (s parseTerm: each  second).
		string := unification printString.
		self assert: (string allButFirst: (string findString: '(') - 1) equals: each third.
		unification ]
]

{ #category : #example }
LbTermExamples >> parserForFooBar [
	<gtExample>
	| signature |
	signature := LbSignatureExamples new signatureFooBar.
	^ LbTermParser signature: signature
]

{ #category : #example }
LbTermExamples >> rationalNumberLiteralTerms [
	<gtExample>
	| inputs |
	inputs := {
		0 -> #zero.
		2 -> #'ℕ.nz'.
		-2 -> #'ℤ.nz'.
		2/3 -> #'ℚ.p'.
		-2/3 -> #'ℚ.nz'.
	}.
	^ inputs collect: [ :each |
		| t |
		t := LbBuiltinSignatures rationalNumberSignature atomicTerm: each key.
		self assert: t sort name equals: each value.
		self assert: t headOpName asSymbol equals: #Atomic.
		t ]
]

{ #category : #example }
LbTermExamples >> stringTerm [
	<gtExample>
	| t |
	t := LbBuiltinSignatures stringSignature atomicTerm: 'abc'.
	self assert: t sort name equals: #string.
	self assert: t headOpName asSymbol equals: #Atomic.
	^ t
]

{ #category : #example }
LbTermExamples >> substitutedTerms [
	<gtExample>
	| s |
	s := LbSignatureExamples new booleanSignature.
	^ {
	self
		check: 'true'
		withSubstitution: (Dictionary new)
		equals: 'true'
		signature: s.
	self
		check: 'X'
		withSubstitution: (Dictionary with: #X -> 'true')
		equals: 'true'
		signature: s.
	self
		check: '¬(X)'
		withSubstitution: (Dictionary with: #X -> 'true')
		equals: '¬(true)'
		signature: s.
	self
		check: 'X ⊻ X'
		withSubstitution: (Dictionary with: #X -> 'true')
		equals: 'true ⊻ true'
		signature: s.
	self
		check: 'X ⊻ Y'
		withSubstitution: (Dictionary with: #X -> 'true')
		equals: 'true ⊻ Y'
		signature: s.
	self
		check: 'X ⊻ Y'
		withSubstitution: (Dictionary with: #X -> 'true' with: #Y -> 'false')
		equals: 'true ⊻ false'
		signature: s.
	}
]

{ #category : #example }
LbTermExamples >> termFoo [
	<gtExample>
	^ self parserForFooBar parse: 'foo'
]

{ #category : #example }
LbTermExamples >> termFooBracketFooOfFoo [
	<gtExample>
	| signature sortA |
	signature := LbSignatureExamples new signatureFooBar.
	sortA := signature sortNamed: #A.
	^ LbOpTerm
		name: LbBracketOperatorName new
		args: { self termFooExplicit. self termFooOfFoo }
		sort: sortA
		signature: signature
]

{ #category : #example }
LbTermExamples >> termFooExplicit [
	<gtExample>
	| signature |
	signature := LbSignatureExamples new signatureFooBar.
	^ LbOpTerm
		name: (LbPrefixOperatorName for: #foo)
		args: #()
		sort: (signature sortNamed: #A)
		signature: signature
]

{ #category : #example }
LbTermExamples >> termFooOfFoo [
	<gtExample>
	| signature sortA |
	signature := LbSignatureExamples new signatureFooBar.
	sortA := signature sortNamed: #A.
	^ LbOpTerm
		name: (LbPrefixOperatorName for: #foo)
		args: { self termFooExplicit }
		sort: sortA
		signature: signature
]

{ #category : #example }
LbTermExamples >> termFooPlusFooExplicit [
	<gtExample>
	| signature sortA |
	signature := LbSignatureExamples new signatureFooBar.
	sortA := signature sortNamed: #A.
	^ LbOpTerm
		name: (LbInfixOperatorName for: #+)
		args: { self termFooExplicit. self termFooExplicit }
		sort: sortA
		signature: signature
]

{ #category : #example }
LbTermExamples >> termSyntax [
	<gtExample>
	^ {
		{ LbBuiltinSignatures truthSignature.
			'true'. 'false'. }.
		{ LbBuiltinSignatures integerSignature.
			'2'. 'abs(-2)'. '2 + 3 + 4 + 5'.
			'(2 + 3) × (2 - 7)'. '(3 - -4) div (-2 × 1)'.
			'(2 + 3 + 4) rem 5'. '2^{3}'. '2^{2^{3}}'.
			'(2 - 4)^{3}'. }.
		{ LbBuiltinSignatures rationalNumberSignature.
			'2/3'. 'abs(-2/3)'. '2/3^{3}'.
			'2/3 + 3/4 + 1/7'.
			'(2/3 + 3/4 + 1/7) ÷ -3/4'. '1/7 < 3/4'. }.
		{ LbBuiltinSignatures fpNumberSignature.
			'2.5'. 'abs(-2.5)'. '√(2.5)'.
			'2.3 + 3.4'. '2.3^{3.2}'. }.
		{ LbSignatureExamples new booleanSignature.
			'true'. '¬(false)'. 'X ⊻ Y ⊻ (X ∧ Y)'. 'true ⊻ false ⊻ X ⊻ Y'. }.
	} flatCollect: [ :each |
		each allButFirst collect: [ :eachString |
			self
				checkSyntaxRoundTrip: eachString
				signature: each first ] ]
]

{ #category : #example }
LbTermExamples >> varTerm [
	<gtExample>
	| term |
	term := self parserForFooBar parse: 'bar'.
	self assert: term headOpName asSymbol equals: #Variable.
	^ term
]
