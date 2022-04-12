"
Builtin contexts are contexts that cannot be defined in Leibniz itself, because they make use of builtin terms such as numbers or strings. {{gtMethod:name=LzBuiltinContexts class>>#truthContext}} is an exception: it could very well be defined as a standard Leibniz context, but since it is used by the number contexts, it is part of the builtin contexts as well.

"
Class {
	#name : #LzBuiltinContexts,
	#superclass : #Object,
	#classVars : [
		'EqualityContext',
		'IntegerContext',
		'RationalNumberContext',
		'StringContext',
		'TruthContext'
	],
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #accessing }
LzBuiltinContexts class >> arrayContext [
	| builder |
	builder := LzContextBuilder new
				includeSortContext: LzBuiltinContexts integerContext;
				include: LzBuiltinContexts integerContext;
				builtin: #arrays.
	self arraySortsFor: builder.
	self arrayOpsFor: builder.
	^ builder context
]

{ #category : #accessing }
LzBuiltinContexts class >> arrayOpsFor: builder [
	builder
		op: '∀ s_:𝕊 shape(Array(s_)) : Array(ℕ)';
		rule: '∀ s__:𝕊 ∀ A_:Array(s__) shape(A_) → ''A shapeAsArrayTerm'':nil'.
]

{ #category : #private }
LzBuiltinContexts class >> arraySortsFor: builder [
	builder
		sort: 'Array(𝕊)';
		sort: 'Array(𝕊, ℕ)';
		subsort: '∀ s_:𝕊 ∀ i1_:ℕ ',
					'Array(s_, i1_) ⊆ Array(s_)';
		sort: 'Array(𝕊, ℕ, ℕ)';
		subsort: '∀ s_:𝕊 ∀ i1_:ℕ ∀ i2_:ℕ ',
					'Array(s_, i1_, i2_) ⊆ Array(s_, i1_)';
		sort: 'Array(𝕊, ℕ, ℕ, ℕ)';
		subsort: '∀ s_:𝕊 ∀ i1_:ℕ ∀ i2_:ℕ ∀ i3_:ℕ ',
					'Array(s_, i1_, i2_, i3_) ⊆ Array(s_, i1_, i2_)';
		sort: 'Array(𝕊, ℕ, ℕ, ℕ, ℕ)';
		subsort: '∀ s_:𝕊 ∀ i1_:ℕ ∀ i2_:ℕ ∀ i3_:ℕ ∀ i4_:ℕ ',
					'Array(s_, i1_, i2_, i3_, i4_) ⊆ Array(s_, i1_, i2_, i3_)'
]

{ #category : #accessing }
LzBuiltinContexts class >> equalityContext [
	EqualityContext ifNil: [
		| builder |
		builder := LzContextBuilder new
			include: self truthContext;
			op: '∀ s_:𝕊 s_ == s_ : 𝔹';
			axiom: '∀ s__:𝕊 ∀ x_:s__ ∀ y_:s__ (x_ == y_) = (y_ == x_)';
			rule: '∀ s__:𝕊 ∀ X_:s__ ∀ Y_:s__ X_ == Y_ → ''X = Y'':LzBooleanTerm'.
		EqualityContext := builder context ].
	^ EqualityContext
]

{ #category : #private }
LzBuiltinContexts class >> integerAxiomsFor: aContextBuilder [
	aContextBuilder
		"addition axioms"
		axiom: '∀ x_:ℤ ∀ y_:ℤ  x_ + y_ = y_ + x_';
		axiom: '∀ x_:ℤ ∀ y_:ℤ  ∀ z_:ℤ  (x_ + y_) + z_ = x_ + (y_ + z_)';
		"multiplication axioms"
		axiom: '∀ x_:ℤ ∀ y_:ℤ  x_ × y_ = y_ × x_';
		axiom: '∀ x_:ℤ ∀ y_:ℤ  ∀ z_:ℤ  (x_ × y_) × z_ = x_ × (y_ × z_)'.
]

{ #category : #accessing }
LzBuiltinContexts class >> integerContext [
	IntegerContext ifNil: [
		| builder |
		builder := LzContextBuilder new
			include: self truthContext;
			builtin: #integers.
		self integerSortsFor: builder.
		self integerOpsFor: builder.
		self integerAxiomsFor: builder.
		self integerRulesFor: builder.
		IntegerContext := builder context ].
	^ IntegerContext
]

{ #category : #private }
LzBuiltinContexts class >> integerOpsFor: aContextBuilder [
	aContextBuilder
		"Predecessor and successor for natural numbers"
		op: 'succ(ℕ) : ℕ.nz';
		op: 'pred(ℕ.nz) : ℕ';
		"Arithmetic operators"
		op: 'ℤ + ℤ : ℤ';
		op: 'ℕ + ℕ : ℕ';
		op: 'ℕ.nz + ℕ.nz : ℕ.nz';
		op: 'ℕ.nz + ℕ : ℕ.nz';
		op: 'ℕ + ℕ.nz : ℕ.nz';
		op: 'ℤ - ℤ : ℤ';
		op: '-(ℤ) : ℤ';
		op: 'ℤ × ℤ : ℤ';
		op: 'ℕ × ℕ : ℕ';
		op: 'ℕ.nz × ℕ.nz : ℕ.nz';
		op: 'ℤ.nz × ℤ.nz : ℤ.nz';
		op: 'ℤ div ℤ.nz : ℤ';
		op: 'ℕ div ℕ.nz : ℕ';
		op: 'ℤ rem ℤ.nz : ℤ';
		op: 'ℕ rem ℕ.nz : ℕ';
		op: 'ℤ^(ℕ.nz) : ℤ';
		op: 'ℕ^(ℕ.nz) : ℕ';
		op: 'ℕ.nz^(ℕ.nz) : ℕ.nz';
		op: 'ℤ.nz^(ℕ.nz) : ℤ.nz';
		op: 'ℤ.nz^(zero) : ℕ.nz';
		op: 'abs(ℤ) : ℕ';
		op: 'abs(ℤ.nz) : ℕ.nz';
		"Comparison operators"
		op: 'ℤ < ℤ : 𝔹';
		op: 'ℤ > ℤ : 𝔹';
		op: 'ℤ ≤ ℤ : 𝔹';
		op: 'ℤ ≥ ℤ : 𝔹'.
]

{ #category : #private }
LzBuiltinContexts class >> integerRulesFor: aContextBuilder [
	aContextBuilder
		"predecessor/successor rules"
		rule: '∀ x_:ℕ.nz pred(x_) → ''x - 1'':LzIntegerTerm';
		rule: '∀ x_:ℕ succ(x_) → ''x + 1'':LzIntegerTerm';
		"addition rules"
		rule: '∀ x_:ℤ ∀ zero_:zero x_ + zero_ ⇒ x_';
		rule: '∀ x_:ℤ ∀ zero_:zero zero_ + x_ ⇒ x_';
		rule: '∀ x_:ℤ ∀ y_:ℤ x_ + y_ → ''x + y'':LzIntegerTerm';
		"subtraction rules"
		rule: '∀ x_:ℤ ∀ zero_:zero x_ - zero_ ⇒ x_';
		rule: '∀ x_:ℤ ∀ zero_:zero zero_ - x_ ⇒ -(x_)';
		rule: '∀ x_:ℤ ∀ y_:ℤ x_ - y_ → ''x - y'':LzIntegerTerm';
		rule: '∀ zero_:zero -(zero_) ⇒ 0';
		rule: '∀ x_:ℤ -(x_) → ''x negated'':LzIntegerTerm';
		"multiplication rules"
		rule: '∀ x_:ℤ ∀ zero_:zero x_ × zero_ ⇒ 0';
		rule: '∀ x_:ℤ ∀ zero_:zero zero_ × x_ ⇒ 0';
		rule: '∀ x_:ℤ 1 × x_ ⇒ x_';
		rule: '∀ x_:ℤ x_ × 1 ⇒ x_';
		rule: '∀ x_:ℤ ∀ y_:ℤ x_ × y_ → ''x * y'':LzIntegerTerm';
		"division rules"
		rule: '∀ x_:ℤ.nz ∀ zero_:zero zero_ div x_ ⇒ 0';
		rule: '∀ x_:ℤ x_ div 1 ⇒ x_';
		rule: '∀ x_:ℤ ∀ y_:ℤ.nz x_ div y_ → ''(x abs // y abs) * x sign * y sign'':LzIntegerTerm';
		rule: '∀ x_:ℤ.nz ∀ zero_:zero zero_ rem x_ ⇒ 0';
		rule: '∀ x_:ℤ x_ rem 1 ⇒ 0';
		rule: '∀ x_:ℤ ∀ y_:ℤ.nz x_ rem y_ → ''(x abs % y abs) * x sign * y sign'':LzIntegerTerm';
		"exponentiation rules"
		rule: '∀ x_:ℤ.nz ∀ zero_:zero x_^(zero_) ⇒ 1';
		rule: '∀ x_:ℕ.nz ∀ zero_:zero zero_^(x_) ⇒ 0';
		rule: '∀ x_:ℤ ∀ y_:ℕ.nz x_^(y_) → ''x raisedTo: y'':LzIntegerTerm';
		"abs rules"
		rule: '∀ x_:ℕ abs(x_) ⇒ x_';
		rule: '∀ x_:ℤ abs(x_) ⇒ -(x_) | x_ < 0';
		rule: '∀ x_:ℤ abs(x_) → ''x abs'':LzIntegerTerm';
		"comparison rules"
		rule: '∀ x_:ℤ ∀ y_:ℤ x_ < y_ → ''x < y'':LzBooleanTerm';
		rule: '∀ x_:ℤ ∀ y_:ℤ x_ > y_ → ''x > y'':LzBooleanTerm';
		rule: '∀ x_:ℤ ∀ y_:ℤ x_ ≤ y_ → ''x <= y'':LzBooleanTerm';
		rule: '∀ x_:ℤ ∀ y_:ℤ x_ ≥ y_ → ''x >= y'':LzBooleanTerm'.
]

{ #category : #private }
LzBuiltinContexts class >> integerSortsFor: aContextBuilder [
	aContextBuilder
		"Natural numbers"
		sort: 'ℕ';
		sort: 'ℕ.nz';
		sort: 'zero';
		subsort: 'zero ⊆ ℕ';
		subsort: 'ℕ.nz ⊆ ℕ';
		"Integers"
		sort: 'ℤ';
		sort: 'ℤ.nz';
		subsort: 'ℕ ⊆ ℤ';
		subsort: 'ℤ.nz ⊆ ℤ';
		subsort: 'ℕ.nz ⊆ ℤ.nz'.
]

{ #category : #private }
LzBuiltinContexts class >> rationalAxiomsFor: aContextBuilder [
	aContextBuilder
		"addition axioms"
		axiom: '∀ x_:ℚ ∀ y_:ℚ  x_ + y_ = y_ + x_';
		axiom: '∀ x_:ℚ ∀ y_:ℚ  ∀ z_:ℚ  (x_ + y_) + z_ = x_ + (y_ + z_)';
		"multiplication axioms"
		axiom: '∀ x_:ℚ ∀ y_:ℚ  x_ × y_ = y_ × x_';
		axiom: '∀ x_:ℚ ∀ y_:ℚ  ∀ z_:ℚ  (x_ × y_) × z_ = x_ × (y_ × z_)'.
]

{ #category : #accessing }
LzBuiltinContexts class >> rationalNumberContext [
	RationalNumberContext ifNil: [
		| builder |
		builder := LzContextBuilder new
			include: self truthContext;
			builtin: #integers;
			builtin: #rationalNumbers.
		self integerSortsFor: builder.
		self rationalSortsFor: builder.
		self integerOpsFor: builder.
		self rationalOpsFor: builder.
		"No integerAxioms, because they would be redundant."
		self rationalAxiomsFor:  builder.
		"No integerRules, the few that are required are repeated in rationalRules."
		self rationalRulesFor: builder.
		RationalNumberContext := builder context ].
	^ RationalNumberContext
]

{ #category : #private }
LzBuiltinContexts class >> rationalOpsFor: aContextBuilder [
	aContextBuilder
		"Arithmetic operators"
		op: 'ℚ + ℚ : ℚ';
		op: 'ℚ.p + ℚ.p : ℚ.p';
		op: 'ℚ.nn + ℚ.nn : ℚ.nn';
		op: 'ℚ - ℚ : ℚ';
		op: '-(ℚ) : ℚ';
		op: 'ℚ × ℚ : ℚ';
		op: 'ℚ.p × ℚ.p : ℚ.p';
		op: 'ℚ.nn × ℚ.nn : ℚ.nn';
		op: 'ℚ.nz × ℚ.nz : ℚ.nz';
		op: 'ℚ ÷ ℚ.nz : ℚ';
		op: 'ℚ.nz ÷ ℚ.nz : ℚ.nz';
		op: 'ℚ.nn ÷ ℚ.p : ℚ.nn';
		op: 'ℚ.p ÷ ℚ.p : ℚ.p';
		op: 'ℚ.nz^(ℤ.nz) : ℚ.nz';
		op: 'ℚ.p^(ℤ.nz) : ℚ.p';
		op: 'ℚ.nz^(zero) : ℕ.nz';
		op: 'abs(ℚ) : ℚ.nn';
		op: 'abs(ℚ.nz) : ℚ.p';
		"Comparison operators"
		op: 'ℚ < ℚ : 𝔹';
		op: 'ℚ > ℚ : 𝔹';
		op: 'ℚ ≤ ℚ : 𝔹';
		op: 'ℚ ≥ ℚ : 𝔹'.
]

{ #category : #private }
LzBuiltinContexts class >> rationalRulesFor: aContextBuilder [
	aContextBuilder
		"addition rules"
		rule: '∀ x_:ℚ ∀ z_:zero x_ + z_ ⇒ x_';
		rule: '∀ x_:ℚ ∀ z_:zero z_ + x_ ⇒ x_';
		rule: '∀ x_:ℚ ∀ y_:ℚ x_ + y_ → ''x + y'':LzRationalNumberTerm';
		rule: '∀ x_:ℤ ∀ y_:ℤ x_ + y_ → ''x + y'':LzIntegerTerm';
		"Subtraction rules"
		rule: '∀ x_:ℚ ∀ z_:zero x_ - z_ ⇒ x_';
		rule: '∀ x_:ℚ ∀ z_:zero z_ - x_ ⇒ -(x_)';
		rule: '∀ x_:ℤ ∀ y_:ℤ x_ - y_ → ''x - y'':LzIntegerTerm';
		rule: '∀ x_:ℚ ∀ y_:ℚ x_ - y_ → ''x - y'':LzRationalNumberTerm';
		"Negation rules"
		rule: '∀ z_:zero -(z_) ⇒ 0';
		rule: '∀ x_:ℤ -(x_) → ''x negated'':LzIntegerTerm';
		rule: '∀ x_:ℚ -(x_) → ''x negated'':LzRationalNumberTerm';
		"Multiplication rules"
		rule: '∀ x_:ℚ ∀ z_:zero x_ × z_ ⇒ 0';
		rule: '∀ x_:ℚ ∀ z_:zero z_ × x_ ⇒ 0';
		rule: '∀ x_:ℚ 1 × x_ ⇒ x_';
		rule: '∀ x_:ℚ x_ × 1 ⇒ x_';
		rule: '∀ x_:ℤ ∀ y_:ℤ x_ × y_ → ''x * y'':LzIntegerTerm';
		rule: '∀ x_:ℚ ∀ y_:ℚ x_ × y_ → ''x * y'':LzRationalNumberTerm';
		"Division rules"
		rule: '∀ x_:ℚ.nz ∀ z_:zero z_ ÷ x_ ⇒ 0';
		rule: '∀ x_:ℚ x_ ÷ 1 ⇒ x_';
		rule: '∀ x_:ℚ ∀ y_:ℚ.nz x_ ÷ y_ → ''x / y'':LzRationalNumberTerm';
		"Integer div and rem rules"
		rule: '∀ x_:ℤ.nz ∀ z_:zero z_ div x_ ⇒ 0';
		rule: '∀ x_:ℤ x_ div 1 ⇒ x_';
		rule: '∀ x_:ℤ ∀ y_:ℤ.nz x_ div y_ → ''(x abs // y abs) * x sign * y sign'':LzIntegerTerm';
		rule: '∀ x_:ℤ.nz ∀ z_:zero z_ rem x_ ⇒ 0';
		rule: '∀ x_:ℤ x_ rem 1 ⇒ 0';
		rule: '∀ x_:ℤ ∀ y_:ℤ.nz x_ rem y_ → ''(x abs % y abs) * x sign * y sign'':LzIntegerTerm';
		"Exponentiation rules"
		rule: '∀ x_:ℚ.nz ∀ z_:zero x_^(z_) ⇒ 1';
		rule: '∀ x_:ℕ.nz ∀ z_:zero z_^(x_) ⇒ 0';
		rule: '∀ x_:ℤ ∀ y_:ℕ.nz x_^(y_) → ''x raisedTo: y'':LzIntegerTerm';
		rule: '∀ x_:ℚ.nz ∀ y_:ℤ.nz x_^(y_) → ''x raisedTo: y'':LzRationalNumberTerm';
		"Abs rules"
		rule: '∀ x_:ℚ.nn abs(x_) ⇒ x_';
		rule: '∀ x_:ℚ abs(x_) ⇒ -(x_) | x_ < 0';
		rule: '∀ x_:ℤ abs(x_) → ''x abs'':LzIntegerTerm';
		rule: '∀ x_:ℚ abs(x_) → ''x abs'':LzRationalNumberTerm';
		"Comparison rules"
		rule: '∀ x_:ℚ ∀ y_:ℚ x_ < y_ → ''x < y'':LzBooleanTerm';
		rule: '∀ x_:ℚ ∀ y_:ℚ x_ > y_ → ''x > y'':LzBooleanTerm';
		rule: '∀ x_:ℚ ∀ y_:ℚ x_ ≤ y_ → ''x <= y'':LzBooleanTerm';
		rule: '∀ x_:ℚ ∀ y_:ℚ x_ ≥ y_ → ''x >= y'':LzBooleanTerm'.
]

{ #category : #private }
LzBuiltinContexts class >> rationalSortsFor: aContextBuilder [
	aContextBuilder
		"Rational numbers"
		sort: 'ℚ';
		sort: 'ℚ.nn';
		sort: 'ℚ.nz';
		sort: 'ℚ.p';
		subsort: 'ℚ.nz ⊆ ℚ';
		subsort: 'ℚ.p ⊆ ℚ.nz';
		subsort: 'ℚ.nn ⊆ ℚ';
		subsort: 'ℚ.p ⊆ ℚ.nn';
		subsort: 'ℕ ⊆ ℚ.nn';
		subsort: 'ℕ.nz ⊆ ℚ.p';
		subsort: 'ℤ ⊆ ℚ';
		subsort: 'ℤ.nz ⊆ ℚ.nz'.
]

{ #category : #resetting }
LzBuiltinContexts class >> reset [
	TruthContext := nil.
	IntegerContext := nil.
	RationalNumberContext := nil.
	StringContext := nil.
]

{ #category : #accessing }
LzBuiltinContexts class >> sortContext [
	^ LzSortHierarchyRoot uniqueInstance sortContext
]

{ #category : #accessing }
LzBuiltinContexts class >> stringContext [
	StringContext ifNil: [
		StringContext :=
			LzContextBuilder new
				builtin: #strings;
				sort: 'string';
				op: 'string + string : string';
				rule: '∀ a_:string ∀ b_:string a_ + b_ → ''a, b'':LzStringTerm';
				context ].
	^ StringContext
]

{ #category : #accessing }
LzBuiltinContexts class >> truthContext [
	TruthContext ifNil: [
		TruthContext :=
			LzContextBuilder new
				sort: '𝔹';
				op: '⊤ : 𝔹';
				op: '⊥ : 𝔹';
				context ].
	^ TruthContext
]
