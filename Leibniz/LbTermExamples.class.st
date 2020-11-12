Class {
	#name : #LbTermExamples,
	#superclass : #Object,
	#traits : 'TGtExampleAssertable',
	#classTraits : 'TGtExampleAssertable classTrait',
	#category : #'Leibniz-3-Terms'
}

{ #category : #example }
LbTermExamples >> booleanTerm [
	<gtExample>
	| t |
	t := LbBuiltinSignatures truthSignature zeroArgTermNamed: (LbPrefixOperatorName for: #true).
	self assert: t sort name equals: #boolean.
	^ t
]

{ #category : #private }
LbTermExamples >> checkSyntaxRoundTrip: aString signature: aSignature [
	| term |
	term := (LbTermParser forSignature: aSignature)
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
LbTermExamples >> parserForFooBar [
	<gtExample>
	| signature |
	signature := LbSignatureExamples new signatureFooBar.
	^ LbTermParser forSignature: signature
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
		t ]
]

{ #category : #example }
LbTermExamples >> stringTerm [
	<gtExample>
	| t |
	t := LbBuiltinSignatures stringSignature atomicTerm: 'abc'.
	self assert: t sort name equals: #string.
	^ t
]

{ #category : #example }
LbTermExamples >> termFoo [
	<gtExample>
	^ self parserForFooBar parse: 'foo'
]

{ #category : #example }
LbTermExamples >> termFooBracketFooOfFoo [
	<gtExample>
	| signature sortGraph sortA |
	signature := LbSignatureExamples new signatureFooBar.
	sortGraph := signature sortGraph.
	sortA := sortGraph sortNamed: #A.
	^ LbOpTerm
		name: LbBracketOperatorName new
		args: { self termFooExplicit. self termFooOfFoo }
		sort: sortA
		forSignature: signature
]

{ #category : #example }
LbTermExamples >> termFooExplicit [
	<gtExample>
	| signature sortGraph |
	signature := LbSignatureExamples new signatureFooBar.
	sortGraph := signature sortGraph.
	^ LbOpTerm
		name: (LbPrefixOperatorName for: #foo)
		args: #()
		sort: (sortGraph sortNamed: #A)
		forSignature: signature
]

{ #category : #example }
LbTermExamples >> termFooOfFoo [
	<gtExample>
	| signature sortGraph sortA |
	signature := LbSignatureExamples new signatureFooBar.
	sortGraph := signature sortGraph.
	sortA := sortGraph sortNamed: #A.
	^ LbOpTerm
		name: (LbPrefixOperatorName for: #foo)
		args: { self termFooExplicit }
		sort: sortA
		forSignature: signature
]

{ #category : #example }
LbTermExamples >> termFooPlusFooExplicit [
	<gtExample>
	| signature sortGraph sortA |
	signature := LbSignatureExamples new signatureFooBar.
	sortGraph := signature sortGraph.
	sortA := sortGraph sortNamed: #A.
	^ LbOpTerm
		name: (LbInfixOperatorName for: #+)
		args: { self termFooExplicit. self termFooExplicit }
		sort: sortA
		forSignature: signature
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
