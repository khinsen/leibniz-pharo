Class {
	#name : #LbBuiltinRewriteSystems,
	#superclass : #Object,
	#category : #'Leibniz-4-Rules'
}

{ #category : #builtins }
LbBuiltinRewriteSystems class >> fpNumberRewriteSystem [
	<gtExample>
	^ (LbRewriteSystemBuilder signature: LbBuiltinSignatures fpNumberSignature)
		addRewriteSystem: LbBuiltinRewriteSystems integerRewriteSystem;
		"TODO: add rules for NaN"
		"addition rules"
		parseAndAddRule: '∀ X:FP64 0.0 + X ⇒ X';
		parseAndAddRule: '∀ X:FP64 X + 0.0 ⇒ X';
		parseAndAddRule: '∀ X:FP64 ∀ Y:FP64 X + Y → ''X + Y'':LbFPNumberTerm';
		"Subtraction rules"
		parseAndAddRule: '∀ X:FP64 0.0 - X ⇒ -(X)';
		parseAndAddRule: '∀ X:FP64 X - 0.0 ⇒ X';
		parseAndAddRule: '∀ X:FP64 ∀ Y:FP64 X - Y → ''X - Y'':LbFPNumberTerm';
		"Negation rules"
		parseAndAddRule: '∀ X:FP64 -(X) → ''X negated'':LbFPNumberTerm';
		"Multiplication rules"
		parseAndAddRule: '∀ X:FP64 1.0 × X ⇒ X';
		parseAndAddRule: '∀ X:FP64 X × 1.0 ⇒ X';
		parseAndAddRule: '∀ X:FP64 ∀ Y:FP64 X × Y → ''X * Y'':LbFPNumberTerm';
		"Division rules"
		parseAndAddRule: '∀ X:FP64 X ÷ 1.0 ⇒ X';
		parseAndAddRule: '∀ X:FP64 ∀ Y:FP64 X ÷ Y → ''X / Y'':LbFPNumberTerm';
		"Exponentiation rules"
		parseAndAddRule: '∀ X:FP64 X^{0.0} ⇒ 1.0';
		parseAndAddRule: '∀ X:FP64 X^{0} ⇒ 1.0';
		parseAndAddRule: '∀ N:ℕ 0.0^{N} ⇒ 0.0';
		parseAndAddRule: '∀ X:FP64 ∀ Y:FP64 X^{Y} → ''X raisedTo: Y'':LbFPNumberTerm';
		parseAndAddRule: '∀ X:FP64 ∀ N:ℤ.nz X^{N} → ''X raisedTo: N'':LbFPNumberTerm';
		"Abs rules"
		parseAndAddRule: '∀ X:FP64 abs(X) ⇒ X | X ≥ 0.0';
		parseAndAddRule: '∀ X:FP64 abs(X) ⇒ -(X) | X < 0.0';
		parseAndAddRule: '∀ X:FP64 abs(X) → ''X abs'':LbFPNumberTerm';
		"Comparison rules"
		parseAndAddRule: '∀ X:FP64 ∀ Y:FP64 X < Y → ''X < Y'':LbBooleanTerm';
		parseAndAddRule: '∀ X:FP64 ∀ Y:FP64 X > Y → ''X > Y'':LbBooleanTerm';
		parseAndAddRule: '∀ X:FP64 ∀ Y:FP64 X ≤ Y → ''X <= Y'':LbBooleanTerm';
		parseAndAddRule: '∀ X:FP64 ∀ Y:FP64 X ≥ Y → ''X >= Y'':LbBooleanTerm';
		"Build rewrite system"
		rewriteSystem
]

{ #category : #builtins }
LbBuiltinRewriteSystems class >> integerRewriteSystem [
	<gtExample>
	^ (LbRewriteSystemBuilder signature: LbBuiltinSignatures integerSignature)
		"addition rules"
		parseAndAddRule: '∀ X:ℤ ∀ Zero:zero X + Zero ⇒ X';
		parseAndAddRule: '∀ X:ℤ ∀ Zero:zero Zero + X ⇒ X';
		parseAndAddRule: '∀ X:ℤ ∀ Y:ℤ X + Y → ''X + Y'':LbIntegerTerm';
		"subtraction rules"
		parseAndAddRule: '∀ X:ℤ ∀ Zero:zero X - Zero ⇒ X';
		parseAndAddRule: '∀ X:ℤ ∀ Zero:zero Zero - X ⇒ -(X)';
		parseAndAddRule: '∀ X:ℤ ∀ Y:ℤ X - Y → ''X - Y'':LbIntegerTerm';
		parseAndAddRule: '∀ Zero:zero -(Zero) ⇒ 0';
		parseAndAddRule: '∀ X:ℤ -(X) → ''X negated'':LbIntegerTerm';
		"multiplication rules"
		parseAndAddRule: '∀ X:ℤ ∀ Zero:zero X × Zero ⇒ 0';
		parseAndAddRule: '∀ X:ℤ ∀ Zero:zero Zero × X ⇒ 0';
		parseAndAddRule: '∀ X:ℤ 1 × X ⇒ X';
		parseAndAddRule: '∀ X:ℤ X × 1 ⇒ X';
		parseAndAddRule: '∀ X:ℤ ∀ Y:ℤ X × Y → ''X * Y'':LbIntegerTerm';
		"division rules"
		parseAndAddRule: '∀ X:ℤ.nz ∀ Zero:zero Zero div X ⇒ 0';
		parseAndAddRule: '∀ X:ℤ X div 1 ⇒ X';
		parseAndAddRule: '∀ X:ℤ ∀ Y:ℤ.nz X div Y → ''(X abs // Y abs) * X sign * Y sign'':LbIntegerTerm';
		parseAndAddRule: '∀ X:ℤ.nz ∀ Zero:zero Zero rem X ⇒ 0';
		parseAndAddRule: '∀ X:ℤ X rem 1 ⇒ 0';
		parseAndAddRule: '∀ X:ℤ ∀ Y:ℤ.nz X rem Y → ''(X abs % Y abs) * X sign * Y sign'':LbIntegerTerm';
		"exponentiation rules"
		parseAndAddRule: '∀ X:ℤ.nz ∀ Zero:zero X^{Zero} ⇒ 1';
		parseAndAddRule: '∀ X:ℕ.nz ∀ Zero:zero Zero^{X} ⇒ 0';
		parseAndAddRule: '∀ X:ℤ ∀ Y:ℕ.nz X^{Y} → ''X raisedTo: Y'':LbIntegerTerm';
		"abs rules"
		parseAndAddRule: '∀ X:ℕ abs(X) ⇒ X';
		parseAndAddRule: '∀ X:ℤ abs(X) ⇒ -(X) | X < 0';
		parseAndAddRule: '∀ X:ℤ abs(X) → ''X abs'':LbIntegerTerm';
		"comparison rules"
		parseAndAddRule: '∀ X:ℤ ∀ Y:ℤ X < Y → ''X < Y'':LbBooleanTerm';
		parseAndAddRule: '∀ X:ℤ ∀ Y:ℤ X > Y → ''X > Y'':LbBooleanTerm';
		parseAndAddRule: '∀ X:ℤ ∀ Y:ℤ X ≤ Y → ''X <= Y'':LbBooleanTerm';
		parseAndAddRule: '∀ X:ℤ ∀ Y:ℤ X ≥ Y → ''X >= Y'':LbBooleanTerm';
		"build the rewrite system"
		rewriteSystem
]

{ #category : #builtins }
LbBuiltinRewriteSystems class >> rationalNumberRewriteSystem [
	<gtExample>
	^ (LbRewriteSystemBuilder signature: LbBuiltinSignatures rationalNumberSignature)
		"addition rules"
		parseAndAddRule: '∀ X:ℚ ∀ Zero:zero X + Zero ⇒ X';
		parseAndAddRule: '∀ X:ℚ ∀ Zero:zero Zero + X ⇒ X';
		parseAndAddRule: '∀ X:ℚ ∀ Y:ℚ X + Y → ''X + Y'':LbRationalNumberTerm';
		"Subtraction rules"
		parseAndAddRule: '∀ X:ℚ ∀ Zero:zero X - Zero ⇒ X';
		parseAndAddRule: '∀ X:ℚ ∀ Zero:zero Zero - X ⇒ -(X)';
		parseAndAddRule: '∀ X:ℚ ∀ Y:ℚ X - Y → ''X - Y'':LbRationalNumberTerm';
		"Negation rules"
		parseAndAddRule: '∀ Zero:zero -(Zero) ⇒ 0';
		parseAndAddRule: '∀ X:ℚ -(X) → ''X negated'':LbRationalNumberTerm';
		"Multiplication rules"
		parseAndAddRule: '∀ X:ℚ ∀ Zero:zero X × Zero ⇒ 0';
		parseAndAddRule: '∀ X:ℚ ∀ Zero:zero Zero × X ⇒ 0';
		parseAndAddRule: '∀ X:ℚ 1 × X ⇒ X';
		parseAndAddRule: '∀ X:ℚ X × 1 ⇒ X';
		parseAndAddRule: '∀ X:ℚ ∀ Y:ℚ X × Y → ''X * Y'':LbRationalNumberTerm';
		"Division rules"
		parseAndAddRule: '∀ X:ℚ.nz ∀ Zero:zero Zero ÷ X ⇒ 0';
		parseAndAddRule: '∀ X:ℚ X ÷ 1 ⇒ X';
		parseAndAddRule: '∀ X:ℚ ∀ Y:ℚ.nz X ÷ Y → ''X / Y'':LbRationalNumberTerm';
		"Integer div and rem rules"
		parseAndAddRule: '∀ X:ℤ.nz ∀ Zero:zero Zero div X ⇒ 0';
		parseAndAddRule: '∀ X:ℤ X div 1 ⇒ X';
		parseAndAddRule: '∀ X:ℤ ∀ Y:ℤ.nz X div Y → ''(X abs // Y abs) * X sign * Y sign'':LbIntegerTerm';
		parseAndAddRule: '∀ X:ℤ.nz ∀ Zero:zero Zero rem X ⇒ 0';
		parseAndAddRule: '∀ X:ℤ X rem 1 ⇒ 0';
		parseAndAddRule: '∀ X:ℤ ∀ Y:ℤ.nz X rem Y → ''(X abs % Y abs) * X sign * Y sign'':LbIntegerTerm';
		"Exponentiation rules"
		parseAndAddRule: '∀ X:ℚ.nz ∀ Zero:zero X^{Zero} ⇒ 1';
		parseAndAddRule: '∀ X:ℕ.nz ∀ Zero:zero Zero^{X} ⇒ 0';
		parseAndAddRule: '∀ X:ℚ.nz ∀ Y:ℤ.nz X^{Y} → ''X raisedTo: Y'':LbRationalNumberTerm';
		"Abs rules"
		parseAndAddRule: '∀ X:ℚ.nn abs(X) ⇒ X';
		parseAndAddRule: '∀ X:ℚ abs(X) ⇒ -(X) | X < 0';
		parseAndAddRule: '∀ X:ℚ abs(X) → ''X abs'':LbRationalNumberTerm';
		"Comparison rules"
		parseAndAddRule: '∀ X:ℚ ∀ Y:ℚ X < Y → ''X < Y'':LbBooleanTerm';
		parseAndAddRule: '∀ X:ℚ ∀ Y:ℚ X > Y → ''X > Y'':LbBooleanTerm';
		parseAndAddRule: '∀ X:ℚ ∀ Y:ℚ X ≤ Y → ''X <= Y'':LbBooleanTerm';
		parseAndAddRule: '∀ X:ℚ ∀ Y:ℚ X ≥ Y → ''X >= Y'':LbBooleanTerm';
		"Build rewrite system"
		rewriteSystem
]

{ #category : #accessing }
LbBuiltinRewriteSystems class >> realNumberRewriteSystem [
	<gtExample>
	^ (LbRewriteSystemBuilder signature: LbBuiltinSignatures realNumberSignature)
		"addition rules"
		parseAndAddRule: '∀ X:ℝ ∀ Zero:zero X + Zero ⇒ X';
		parseAndAddRule: '∀ X:ℝ ∀ Zero:zero Zero + X ⇒ X';
		parseAndAddRule: '∀ X:ℚ ∀ Y:ℚ X + Y → ''X + Y'':LbRationalNumberTerm';
		"Subtraction rules"
		parseAndAddRule: '∀ X:ℝ ∀ Zero:zero X - Zero ⇒ X';
		parseAndAddRule: '∀ X:ℝ ∀ Zero:zero Zero - X ⇒ -(X)';
		parseAndAddRule: '∀ X:ℚ ∀ Y:ℚ X - Y → ''X - Y'':LbRationalNumberTerm';
		"Negation rules"
		parseAndAddRule: '∀ Zero:zero -(Zero) ⇒ 0';
		parseAndAddRule: '∀ X:ℚ -(X) → ''X negated'':LbRationalNumberTerm';
		"Multiplication rules"
		parseAndAddRule: '∀ X:ℝ ∀ Zero:zero X × Zero ⇒ 0';
		parseAndAddRule: '∀ X:ℝ ∀ Zero:zero Zero × X ⇒ 0';
		parseAndAddRule: '∀ X:ℝ 1 × X ⇒ X';
		parseAndAddRule: '∀ X:ℝ X × 1 ⇒ X';
		parseAndAddRule: '∀ X:ℚ ∀ Y:ℚ X × Y → ''X * Y'':LbRationalNumberTerm';
		"Division rules"
		parseAndAddRule: '∀ X:ℝ.nz ∀ Zero:zero Zero ÷ X ⇒ 0';
		parseAndAddRule: '∀ X:ℝ X ÷ 1 ⇒ X';
		parseAndAddRule: '∀ X:ℚ ∀ Y:ℚ.nz X ÷ Y → ''X / Y'':LbRationalNumberTerm';
		"Integer div and rem rules"
		parseAndAddRule: '∀ X:ℤ.nz ∀ Zero:zero Zero div X ⇒ 0';
		parseAndAddRule: '∀ X:ℤ X div 1 ⇒ X';
		parseAndAddRule: '∀ X:ℤ ∀ Y:ℤ.nz X div Y → ''(X abs // Y abs) * X sign * Y sign'':LbIntegerTerm';
		parseAndAddRule: '∀ X:ℤ.nz ∀ Zero:zero Zero rem X ⇒ 0';
		parseAndAddRule: '∀ X:ℤ X rem 1 ⇒ 0';
		parseAndAddRule: '∀ X:ℤ ∀ Y:ℤ.nz X rem Y → ''(X abs % Y abs) * X sign * Y sign'':LbIntegerTerm';
		"Exponentiation rules"
		parseAndAddRule: '∀ X:ℝ.nz ∀ Zero:zero X^{Zero} ⇒ 1';
		parseAndAddRule: '∀ X:ℕ.nz ∀ Zero:zero Zero^{X} ⇒ 0';
		parseAndAddRule: '∀ X:ℚ.nz ∀ Y:ℤ.nz X^{Y} → ''X raisedTo: Y'':LbRationalNumberTerm';
		"Abs rules"
		parseAndAddRule: '∀ X:ℝ.nn abs(X) ⇒ X';
		parseAndAddRule: '∀ X:ℝ abs(X) ⇒ -(X) | X < 0';
		parseAndAddRule: '∀ X:ℚ abs(X) → ''X abs'':LbRationalNumberTerm';
		"Comparison rules"
		parseAndAddRule: '∀ X:ℚ ∀ Y:ℚ X < Y → ''X < Y'':LbBooleanTerm';
		parseAndAddRule: '∀ X:ℚ ∀ Y:ℚ X > Y → ''X > Y'':LbBooleanTerm';
		parseAndAddRule: '∀ X:ℚ ∀ Y:ℚ X ≤ Y → ''X <= Y'':LbBooleanTerm';
		parseAndAddRule: '∀ X:ℚ ∀ Y:ℚ X ≥ Y → ''X >= Y'':LbBooleanTerm';
		"Build the rewrite system"
		rewriteSystem
]
