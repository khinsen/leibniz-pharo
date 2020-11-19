Class {
	#name : #LbBuiltinRewriteSystems,
	#superclass : #Object,
	#category : #'Leibniz-4-Rules'
}

{ #category : #example }
LbBuiltinRewriteSystems >> integerRewriteSystem [
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
		parseAndAddRule: '∀ X:ℤ abs(X) → ''X abs'':LbIntegerTerm';
		"comparison rules"
		parseAndAddRule: '∀ X:ℤ ∀ Y:ℤ X < Y → ''X < Y'':LbBooleanTerm';
		parseAndAddRule: '∀ X:ℤ ∀ Y:ℤ X > Y → ''X > Y'':LbBooleanTerm';
		parseAndAddRule: '∀ X:ℤ ∀ Y:ℤ X ≤ Y → ''X <= Y'':LbBooleanTerm';
		parseAndAddRule: '∀ X:ℤ ∀ Y:ℤ X ≥ Y → ''X >= Y'':LbBooleanTerm';
		"build the rewrite system"
		rewriteSystem
]
