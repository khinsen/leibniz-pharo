"
Builtin contexts are contexts that cannot be defined in Leibniz itself, because they make use of builtin terms such as numbers or strings. {{gtMethod:name=LzBuiltinContexts class>>#truthContext}} is an exception: it could very well be defined as a standard Leibniz context, but since it is used by the number contexts, it is part of the builtin contexts as well.

"
Class {
	#name : #LzBuiltinContexts,
	#superclass : #Object,
	#classVars : [
		'ArrayContext',
		'EqualityContext',
		'IntegerContext',
		'RationalNumberContext',
		'RealNumberContext',
		'StringContext',
		'TruthContext'
	],
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #defining }
LzBuiltinContexts class >> arrayAppendContext [
	^ LzContextBuilder new
		include: self arrayContext;
		op: 's_:𝕊, ',
				'(Array1D(s_)) ⧟ (Array1D(s_)) : Array1D(s_)';
		op: 's_:𝕊, n_:ℕ, m_:ℕ, ',
				'(Array(s_, n_)) ⧟ (Array(s_, m_)) : Array(s_, n_ + m_)';
		op: 's_:𝕊, ',
				'(Array1D(s_)) ⧟ (EmptyArray1D) : Array1D(s_)';
		rule: 's__:𝕊, ',
				'A_:Array1D(s__), B_:Array1D(s__), ',
				'A_ ⧟ B_ → ''A ensureArrayTerm. B ensureArrayTerm. A append: B'':nil';
		op: 's_:𝕊, ',
				'(EmptyArray1D) ⧟ (Array1D(s_)) : Array1D(s_)';
		rule: 's__:𝕊, ',
				'e_:EmptyArray1D, a_:Array1D(s__), ',
				'e_ ⧟ a_ ⇒ a_';
		rule: 's__:𝕊, ',
				'e_:EmptyArray1D, a_:Array1D(s__), ',
				'a_ ⧟ e_ ⇒ a_';
		op: 's_:𝕊, ',
				'(EmptyArray1D) ⧟ (EmptyArray1D) : EmptyArray1D';
		rule: 's__:𝕊, ',
				'e1_:EmptyArray1D, e2_:EmptyArray1D, ',
				'e1_ ⧟ e2_ ⇒ e1_';

		op: 's_:𝕊, ',
				'(Array1D(s_)) ⟜ (s_) : Array1D(s_)';
		op: 's_:𝕊, n_:ℕ, ',
				'(Array(s_, n_)) ⟜ (s_) : Array(s_, succ(n_))';
		rule: 's__:𝕊, ',
				'a_:Array1D(s__), v_:s__, ',
				'a_ ⟜ v_ ⇒ a_ ⧟ {[ v_ ]}';
		op: 's_:𝕊, ',
				'(EmptyArray1D) ⟜ (s_) : Array(s_, 1)';
		rule: 's__:𝕊, ',
				'e_:EmptyArray1D, v_:s__, ',
				'e_ ⟜ v_ ⇒ {[ v_ ]}';

		op: 's_:𝕊, ',
				'(s_) ⊸ (Array1D(s_)) : Array1D(s_)';
		op: 's_:𝕊, n_:ℕ, ',
				'(s_) ⊸ (Array(s_, n_)) : Array(s_, succ(n_))';
		rule: 's__:𝕊, ',
				'a_:Array1D(s__), v_:s__, ',
				'v_ ⊸ a_ ⇒ {[ v_ ]} ⧟ a_';
		op: 's_:𝕊, ',
				'(s_) ⊸ (EmptyArray1D) : Array(s_, 1)';
		rule: 's__:𝕊, ',
				'e_:EmptyArray1D, v_:s__, ',
				'v_ ⊸ e_ ⇒ {[ v_ ]}';
		context
]

{ #category : #defining }
LzBuiltinContexts class >> arrayContext [
	ArrayContext ifNil: [
		| builder |
		builder := LzContextBuilder new
					includeSortContext: LzBuiltinContexts integerContext;
					include: LzBuiltinContexts integerContext;
					builtin: #arrays.
		self arraySortsFor: builder.
		self arrayOpsFor: builder.
		ArrayContext := builder context ].
	^ ArrayContext
]

{ #category : #defining }
LzBuiltinContexts class >> arrayFoldContext [
	^ LzContextBuilder new
		include: self arrayContext;
		include: self functionContext;
		op: '∀ s_:𝕊 ',
			'fold(fn(s_, s_, s_), s_, Array1D(s_)) : s_';
		rule: '∀ s__:𝕊 ',
				'∀ F_:fn(s__, s__, s__) ',
				'∀ V_:s__ ',
				'∀ A_:Array1D(s__) ',
				'fold(F_, V_, A_) → ''A ensureArrayTerm. A inject: V into: F reducer: reducer'':nil';
		op: '∀ s_:𝕊 ',
			'fold(fn(s_, s_, s_), s_, EmptyArray) : s_';
		rule: '∀ s__:𝕊 ∀ f_:fn(s__, s__, s__) ',
				'∀ v_:s__ ∀ a_:EmptyArray ',
				'fold(f_, v_, a_) ⇒ v_';
		context
]

{ #category : #defining }
LzBuiltinContexts class >> arrayIndexingContext [
	^ LzContextBuilder new
		include: self arrayContext;
		sort: '⋯';
		op: 'ℕ.nz ⋯ ℕ.nz : ⋯';
		op: '∎ : ℕ.nz';
		op: '∀ s_:𝕊 ',
				'(Array1D(s_))[ℕ.nz] : s_';
		rule: '∀ s__:𝕊 ',
				'∀ A_:Array1D(s__) ',
				'∀ i_:ℕ.nz ',
				'A_[i_] → ''A ensureArrayTerm. A index: i'':nil';
		op: '∀ s_:𝕊 ',
				'(Array1D(s_))[⋯] : Array1D(s_)';
		rule: '∀ s__:𝕊 ',
				'∀ A_:Array1D(s__) ',
				'∀ i_:ℕ.nz ',
				'A_[i_ ⋯ ∎] → ''A ensureArrayTerm. A sliceToEndFrom: i by: 1'':nil';
		rule: '∀ s__:𝕊 ',
				'∀ A_:Array1D(s__) ',
				'∀ i_:ℕ.nz ∀ j_:ℕ.nz ',
				'A_[i_ ⋯ j_] → ''A ensureArrayTerm. A slice: i to: j by: 1'':nil';
		context
]

{ #category : #defining }
LzBuiltinContexts class >> arrayMap2Context [
	^ LzContextBuilder new
		include: self arrayContext;
		include: self functionContext;
		op: 'from1_:𝕊, from2_:𝕊, to_:𝕊, ',
			'(fn(from1_, from2_, to_))[Array(from1_), Array(from2_)] : Array(to_)';
		op: 'from1_:𝕊, from2_:𝕊, to_:𝕊, i_:ℕ, ',
			'(fn(from1_, from2_, to_))[Array(from1_, i_), Array(from2_, i_)] : Array(to_, i_)';
		op: 'from1_:𝕊, from2_:𝕊, to_:𝕊, i_:ℕ, j_:ℕ, ',
			'(fn(from1_, from2_, to_))[Array(from1_, i_, j_), Array(from2_, i_, j_)] : Array(to_, i_, j_)';
		op: 'from1_:𝕊, from2_:𝕊, to_:𝕊, i_:ℕ, j_:ℕ, k_:ℕ, ',
			'(fn(from1_, from2_, to_))[Array(from1_, i_, j_, k_), Array(from2_, i_, j_, k_)] : Array(to_, i_, j_, k_)';
		op: 'from1_:𝕊, from2_:𝕊, to_:𝕊, i_:ℕ, j_:ℕ, k_:ℕ, l_:ℕ, ',
			'(fn(from1_, from2_, to_))[Array(from1_, i_, j_, k_, l_), Array(from2_, i_, j_, k_, l_)] : Array(to_, i_, j_, k_, l_)';
		rule: 'from1__:𝕊, from2__:𝕊, to__:𝕊, ',
				'F_:fn(from1__,, from2__, to__) ',
				'A_:Array(from1__), ',
				'B_:Array(from2__), ',
				'F_[A_, B_] → ''A ensureArrayTerm. B ensureArrayTerm. A with: B applyFn: F reducer: reducer'':nil';

		op: 'from1_:𝕊, from2_:𝕊, to_:𝕊, ',
			'(fn(from1_, from2_, to_))[EmptyArray, EmptyArray] : EmptyArray';
		op: 'from1_:𝕊, from2_:𝕊, to_:𝕊, i_:ℕ, ',
			'(fn(from1_, from2_, to_))[EmptyArray(i_), EmptyArray(i_)] : EmptyArray(i_)';
		op: 'from1_:𝕊, from2_:𝕊, to_:𝕊, i_:ℕ, j_:ℕ, ',
			'(fn(from1_, from2_, to_))[EmptyArray(i_, j_), EmptyArray(i_, j_)] : EmptyArray(i_, j_)';
		op: 'from1_:𝕊, from2_:𝕊, to_:𝕊, i_:ℕ, j_:ℕ, k_:ℕ, ',
			'(fn(from1_, from2_, to_))[EmptyArray(i_, j_, k_), EmptyArray(i_, j_, k_)] : EmptyArray(i_, j_, k_)';
		op: 'from1_:𝕊, from2_:𝕊, to_:𝕊, i_:ℕ, j_:ℕ, k_:ℕ, l_:ℕ, ',
			'(fn(from1_, from2_, to_))[EmptyArray(i_, j_, k_, l_), EmptyArray(i_, j_, k_, l_)] : EmptyArray(i_, j_, k_, l_)';
		rule: 'from1__:𝕊, from2__:𝕊, to__:𝕊, ',
				'f_:fn(from1__,, from2__, to__) ',
				'a_:EmptyArray, ',
				'f_[a_, a_] ⇒ a_';
		context

]

{ #category : #defining }
LzBuiltinContexts class >> arrayMapContext [
	^ LzContextBuilder new
		include: self arrayContext;
		include: self functionContext;
		op: '∀ from_:𝕊 ∀ to_:𝕊 ',
			'(fn(from_, to_))[Array(from_)] : Array(to_)';
		op: '∀ from_:𝕊 ∀ to_:𝕊 ∀ i_:ℕ ',
			'(fn(from_, to_))[Array(from_, i_)] : Array(to_, i_)';
		op: '∀ from_:𝕊 ∀ to_:𝕊 ∀ i_:ℕ ∀ j_:ℕ ',
			'(fn(from_, to_))[Array(from_, i_, j_)] : Array(to_, i_, j_)';
		op: '∀ from_:𝕊 ∀ to_:𝕊 ∀ i_:ℕ ∀ j_:ℕ ∀ k_:ℕ ',
			'(fn(from_, to_))[Array(from_, i_, j_, k_)] : Array(to_, i_, j_, k_)';
		op: '∀ from_:𝕊 ∀ to_:𝕊 ∀ i_:ℕ ∀ j_:ℕ ∀ k_:ℕ ∀ l_:ℕ ',
			'(fn(from_, to_))[Array(from_, i_, j_, k_, l_)] : Array(to_, i_, j_, k_, l_)';
		rule: '∀ from__:𝕊 ∀ to__:𝕊 ∀ F_:fn(from__, to__) ',
				'∀ A_:Array(from__) ',
				'F_[A_] → ''A ensureArrayTerm. A applyFn: F reducer: reducer'':nil';

		op: '∀ from_:𝕊 ∀ to_:𝕊 ',
			'(fn(from_, to_))[EmptyArray] : EmptyArray';
		op: '∀ from_:𝕊 ∀ to_:𝕊 ∀ i_:ℕ ',
			'(fn(from_, to_))[EmptyArray(i_)] : EmptyArray(i_)';
		op: '∀ from_:𝕊 ∀ to_:𝕊 ∀ i_:ℕ ∀ j_:ℕ ',
			'(fn(from_, to_))[EmptyArray(i_, j_)] : EmptyArray(i_, j_)';
		op: '∀ from_:𝕊 ∀ to_:𝕊 ∀ i_:ℕ ∀ j_:ℕ ∀ k_:ℕ ',
			'(fn(from_, to_))[EmptyArray(i_, j_, k_)] : EmptyArray(i_, j_, k_)';
		op: '∀ from_:𝕊 ∀ to_:𝕊 ∀ i_:ℕ ∀ j_:ℕ ∀ k_:ℕ ∀ l_:ℕ ',
			'(fn(from_, to_))[EmptyArray(i_, j_, k_, l_)] : EmptyArray(i_, j_, k_, l_)';
		rule: '∀ from__:𝕊 ∀ to__:𝕊 ∀ f_:fn(from__, to__) ',
				'∀ a_:EmptyArray ',
				'f_[a_] ⇒ a_';
		context
]

{ #category : #private }
LzBuiltinContexts class >> arrayOpsFor: builder [
	builder
		op: '∀ s_:𝕊 shape(Array(s_)) : Array(ℕ)';
		rule: '∀ s__:𝕊 ∀ A_:Array(s__) shape(A_) → ''A shapeAsArrayTerm'':nil'.
]

{ #category : #private }
LzBuiltinContexts class >> arraySortsFor: builder [
	builder
		sort: 'Array(𝕊)';
		sort: 'Array1D(𝕊)';
		subsort: '∀ s_:𝕊 ',
					'Array1D(s_) ⊆ Array(s_)';
		sort: 'Array2D(𝕊)';
		subsort: '∀ s_:𝕊 ',
					'Array2D(s_) ⊆ Array(s_)';
		sort: 'Array3D(𝕊)';
		subsort: '∀ s_:𝕊 ',
					'Array3D(s_) ⊆ Array(s_)';
		sort: 'Array4D(𝕊)';
		subsort: '∀ s_:𝕊 ',
					'Array4D(s_) ⊆ Array(s_)';
		sort: 'Array(𝕊, ℕ)';
		subsort: '∀ s_:𝕊 ∀ i1_:ℕ ',
					'Array(s_, i1_) ⊆ Array1D(s_)';
		sort: 'Array(𝕊, ℕ, ℕ)';
		subsort: '∀ s_:𝕊 ∀ i1_:ℕ ∀ i2_:ℕ ',
					'Array(s_, i1_, i2_) ⊆ Array2D(s_)';
		sort: 'Array(𝕊, ℕ, ℕ, ℕ)';
		subsort: '∀ s_:𝕊 ∀ i1_:ℕ ∀ i2_:ℕ ∀ i3_:ℕ ',
					'Array(s_, i1_, i2_, i3_) ⊆ Array3D(s_)';
		sort: 'Array(𝕊, ℕ, ℕ, ℕ, ℕ)';
		subsort: '∀ s_:𝕊 ∀ i1_:ℕ ∀ i2_:ℕ ∀ i3_:ℕ ∀ i4_:ℕ ',
					'Array(s_, i1_, i2_, i3_, i4_) ⊆ Array3D(s_)';
		sort: 'EmptyArray';
		sort: 'EmptyArray1D';
		sort: 'EmptyArray2D';
		sort: 'EmptyArray3D';
		sort: 'EmptyArray4D';
		subsort: 'EmptyArray1D ⊆ EmptyArray';
		subsort: 'EmptyArray2D ⊆ EmptyArray';
		subsort: 'EmptyArray3D ⊆ EmptyArray';
		subsort: 'EmptyArray4D ⊆ EmptyArray';
		sort: 'EmptyArray(ℕ)';
		subsort: '∀ i1_:ℕ ',
					'EmptyArray(i1_) ⊆ EmptyArray1D';
		sort: 'EmptyArray(ℕ, ℕ)';
		subsort: '∀ i1_:ℕ ∀ i2_:ℕ ',
					'EmptyArray(i1_, i2_) ⊆ EmptyArray2D';
		subsort: '∀ i1_:ℕ ∀ i2_:ℕ ',
					'EmptyArray(i1_, i2_) ⊆ EmptyArray(i1_)';
		sort: 'EmptyArray(ℕ, ℕ, ℕ)';
		subsort: '∀ i1_:ℕ ∀ i2_:ℕ ∀ i3_:ℕ ',
					'EmptyArray(i1_, i2_, i3_) ⊆ EmptyArray3D';
		subsort: '∀ i1_:ℕ ∀ i2_:ℕ ∀ i3_:ℕ ',
					'EmptyArray(i1_, i2_, i3_) ⊆ EmptyArray(i1_, i2_)';
		sort: 'EmptyArray(ℕ, ℕ, ℕ, ℕ)';
		subsort: '∀ i1_:ℕ ∀ i2_:ℕ ∀ i3_:ℕ ∀ i4_:ℕ ',
					'EmptyArray(i1_, i2_, i3_, i4_) ⊆ EmptyArray4D';
		subsort: '∀ i1_:ℕ ∀ i2_:ℕ ∀ i3_:ℕ ∀ i4_:ℕ ',
					'EmptyArray(i1_, i2_, i3_, i4_) ⊆ EmptyArray(i1_, i2_, i3_)'
]

{ #category : #defining }
LzBuiltinContexts class >> equalityContext [
	^ LzBook contextNamed: 'Term equality'
]

{ #category : #defining }
LzBuiltinContexts class >> functionContext [
	^ LzContextBuilder new
		sort: 'from_:𝕊, to_:𝕊, ',
				'fn(from_, to_)';
		op: 'from_:𝕊, to_:𝕊, ',
				'(fn(from_, to_))[from_] : to_';
		sort: 'from1_:𝕊, from2_:𝕊, to_:𝕊, ',
				'fn(from1_, from2_, to_)';
		op: 'from1_:𝕊, from2_:𝕊, to_:𝕊, ',
				'(fn(from1_, from2_, to_))[from1_, from2_] : to_';
		op: 'from1_:𝕊, from2_:𝕊, to_:𝕊, ',
				'(fn(from1_, from2_, to_))[from1_] : fn(from2_, to_)';
		rule: 'from1__:𝕊, from2__:𝕊, to__:𝕊, ',
				'f_:fn(from1__,, from2__, to__) ',
				'a_:from1__, b_:from2__, ',
				'(f_[a_])[b_] ⇒ f_[a_, b_]';
		context
]

{ #category : #private }
LzBuiltinContexts class >> integerAxiomsFor: aContextBuilder [
	aContextBuilder
		"addition axioms"
		axiom: 'x_:ℤ, y_:ℤ , x_ + y_ = y_ + x_';
		axiom: 'x_:ℤ, y_:ℤ , z_:ℤ , (x_ + y_) + z_ = x_ + (y_ + z_)';
		"multiplication axioms"
		axiom: 'x_:ℤ, y_:ℤ , x_ × y_ = y_ × x_';
		axiom: 'x_:ℤ, y_:ℤ , z_:ℤ , (x_ × y_) × z_ = x_ × (y_ × z_)';
		"distribution"
		axiom: 'x_:ℤ, y_:ℤ , z_:ℤ , x_ × (y_ + z_) = (x_ × y_) + (x_ × z_)'
]

{ #category : #defining }
LzBuiltinContexts class >> integerContext [
	^ LzBook contextNamed: 'Integers'
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
		rule: 'x_:ℕ.nz, pred(x_) → ''x - 1'':LzIntegerTerm';
		rule: 'x_:ℕ, succ(x_) → ''x + 1'':LzIntegerTerm';
		"addition rules"
		rule: 'x_:ℤ, zero_:zero, x_ + zero_ ⇒ x_';
		rule: 'x_:ℤ, zero_:zero, zero_ + x_ ⇒ x_';
		rule: 'x_:ℤ, y_:ℤ, x_ + y_ → ''x + y'':LzIntegerTerm';
		"subtraction rules"
		rule: 'x_:ℤ, zero_:zero, x_ - zero_ ⇒ x_';
		rule: 'x_:ℤ, zero_:zero, zero_ - x_ ⇒ -(x_)';
		rule: 'x_:ℤ, y_:ℤ, x_ - y_ → ''x - y'':LzIntegerTerm';
		rule: 'zero_:zero, -(zero_) ⇒ 0';
		rule: 'x_:ℤ, -(x_) → ''x negated'':LzIntegerTerm';
		"multiplication rules"
		rule: 'x_:ℤ, zero_:zero, x_ × zero_ ⇒ 0';
		rule: 'x_:ℤ, zero_:zero, zero_ × x_ ⇒ 0';
		rule: 'x_:ℤ, 1 × x_ ⇒ x_';
		rule: 'x_:ℤ, x_ × 1 ⇒ x_';
		rule: 'x_:ℤ, y_:ℤ, x_ × y_ → ''x * y'':LzIntegerTerm';
		"division rules"
		rule: 'x_:ℤ.nz, zero_:zero, zero_ div x_ ⇒ 0';
		rule: 'x_:ℤ, x_ div 1 ⇒ x_';
		rule: 'x_:ℤ, y_:ℤ.nz, x_ div y_ → ''(x abs // y abs) * x sign * y sign'':LzIntegerTerm';
		rule: 'x_:ℤ.nz, zero_:zero, zero_ rem x_ ⇒ 0';
		rule: 'x_:ℤ, x_ rem 1 ⇒ 0';
		rule: 'x_:ℤ, y_:ℤ.nz, x_ rem y_ → ''(x abs % y abs) * x sign * y sign'':LzIntegerTerm';
		"exponentiation rules"
		rule: 'x_:ℤ.nz, zero_:zero, x_^(zero_) ⇒ 1';
		rule: 'x_:ℕ.nz, zero_:zero, zero_^(x_) ⇒ 0';
		rule: 'x_:ℤ, y_:ℕ.nz, x_^(y_) → ''x raisedTo: y'':LzIntegerTerm';
		"abs rules"
		rule: 'x_:ℕ, abs(x_) ⇒ x_';
		rule: 'x_:ℤ, abs(x_) ⇒ -(x_) | x_ < 0';
		rule: 'x_:ℤ, abs(x_) → ''x abs'':LzIntegerTerm';
		"comparison rules"
		rule: 'x_:ℤ, y_:ℤ, x_ < y_ → ''x < y'':LzBooleanTerm';
		rule: 'x_:ℤ, y_:ℤ, x_ > y_ → ''x > y'':LzBooleanTerm';
		rule: 'x_:ℤ, y_:ℤ, x_ ≤ y_ → ''x <= y'':LzBooleanTerm';
		rule: 'x_:ℤ, y_:ℤ, x_ ≥ y_ → ''x >= y'':LzBooleanTerm'.
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
		sort: 'one';
		subsort: 'one ⊆ ℕ.nz';
		"Integers"
		sort: 'ℤ';
		sort: 'ℤ.nz';
		subsort: 'ℕ ⊆ ℤ';
		subsort: 'ℤ.nz ⊆ ℤ';
		subsort: 'ℕ.nz ⊆ ℤ.nz'.
]

{ #category : #private }
LzBuiltinContexts class >> numberArrayOpsAndRulesForBuilder: builder sort: s [
	builder
		op: '+ : fn(',s,', ',s,', ',s,')';
		rule: 'x_:',s,', y_:',s,', +[x_, y_] ⇒ x_ + y_';
		op: 'i_:ℕ.nz, (Array(',s,', i_)) + (Array(',s,', i_)) : Array(',s,', i_)';
		rule: 'i__:ℕ.nz, a_:Array(',s,',, i__) b_:Array(',s,',, i__) ',
				'a_ + b_ ⇒ +[a_, b_]';
		op: 'i_:zero, (EmptyArray(i_)) + (EmptyArray(i_)) : EmptyArray(i_)';
		rule: 'i__:ℕ, a_:EmptyArray(i__), b_:EmptyArray(i__), a_ + b_ ⇒ a_';

		op: 'Σ(Array1D(',s,')) : ',s,'';
		op: 'i_:ℕ.nz, Σ(Array(',s,', i_)) : ',s,'';
		rule: 'a_:Array1D(',s,')',
			'Σ(a_) ⇒ fold(+, 0, a_)';

		op: '- : fn(',s,', ',s,', ',s,')';
		rule: 'x_:',s,', y_:',s,', -[x_, y_] ⇒ x_ - y_';
		op: 'i_:ℕ.nz, (Array(',s,', i_)) - (Array(',s,', i_)) : Array(',s,', i_)';
		rule: 'i__:ℕ.nz, a_:Array(',s,',, i__) b_:Array(',s,',, i__) ',
				'a_ - b_ ⇒ -[a_, b_]';
		op: 'i_:zero, (EmptyArray(i_)) - (EmptyArray(i_)) : EmptyArray(i_)';
		rule: 'i__:ℕ, a_:EmptyArray(i__), b_:EmptyArray(i__), a_ - b_ ⇒ a_';

		op: '× : fn(',s,', ',s,', ',s,')';
		rule: 'x_:',s,', y_:',s,', ×[x_, y_] ⇒ x_ × y_';
		op: 'i_:ℕ.nz, (Array(',s,', i_)) × (Array(',s,', i_)) : Array(',s,', i_)';
		rule: 'i__:ℕ.nz, a_:Array(',s,',, i__) b_:Array(',s,',, i__) ',
				'a_ × b_ ⇒ ×[a_, b_]';
		op: 'i_:zero, (EmptyArray(i_)) × (EmptyArray(i_)) : EmptyArray(i_)';
		rule: 'i__:ℕ, a_:EmptyArray(i__), b_:EmptyArray(i__), a_ × b_ ⇒ a_';

		op: 'Π(Array1D(',s,')) : ',s,'';
		op: 'i_:ℕ.nz, Π(Array(',s,', i_)) : ',s,'';
		rule: 'a_:Array1D(',s,')',
				'Π(a_) ⇒ fold(×, 1, a_)';

		op: '÷ : fn(',s,', ',s,'.nz, ',s,')';
		rule: 'x_:',s,', y_:',s,'.nz, ÷[x_, y_] ⇒ x_ ÷ y_';
		op: 'i_:ℕ.nz, (Array(',s,', i_)) ÷ (Array(',s,', i_)) : Array(',s,', i_)';
		rule: 'i__:ℕ.nz, a_:Array(',s,',, i__) b_:Array(',s,',, i__) ',
				'a_ ÷ b_ ⇒ ÷[a_, b_]';
		op: 'i_:zero, (EmptyArray(i_)) ÷ (EmptyArray(i_)) : EmptyArray(i_)';
		rule: 'i__:ℕ, a_:EmptyArray(i__), b_:EmptyArray(i__), a_ ÷ b_ ⇒ a_'
]

{ #category : #defining }
LzBuiltinContexts class >> rationalNumberArrayContext [
	| builder |
	builder := LzContextBuilder new
		include: self arrayMap2Context;
		include: self arrayFoldContext;
		include: self rationalNumberContext.
	self numberArrayOpsAndRulesForBuilder: builder sort: 'ℚ'.
	^ builder context
]

{ #category : #private }
LzBuiltinContexts class >> rationalNumberAxiomsFor: aContextBuilder [
	aContextBuilder
		"addition axioms"
		axiom: '∀ x_:ℚ ∀ y_:ℚ  x_ + y_ = y_ + x_';
		axiom: '∀ x_:ℚ ∀ y_:ℚ  ∀ z_:ℚ  (x_ + y_) + z_ = x_ + (y_ + z_)';
		"multiplication axioms"
		axiom: '∀ x_:ℚ ∀ y_:ℚ  x_ × y_ = y_ × x_';
		axiom: '∀ x_:ℚ ∀ y_:ℚ  ∀ z_:ℚ  (x_ × y_) × z_ = x_ × (y_ × z_)';
		"distribution"
		axiom: '∀ x_:ℚ ∀ y_:ℚ  ∀ z_:ℚ  x_ × (y_ + z_) = (x_ × y_) + (x_ × z_)'
]

{ #category : #private }
LzBuiltinContexts class >> rationalNumberBuiltinRulesFor: aContextBuilder [
	aContextBuilder
		"addition rules"
		rule: '∀ x_:ℚ ∀ y_:ℚ x_ + y_ → ''x + y'':LzRationalNumberTerm';
		rule: '∀ x_:ℤ ∀ y_:ℤ x_ + y_ → ''x + y'':LzIntegerTerm';
		"Subtraction rules"
		rule: '∀ x_:ℤ ∀ y_:ℤ x_ - y_ → ''x - y'':LzIntegerTerm';
		rule: '∀ x_:ℚ ∀ y_:ℚ x_ - y_ → ''x - y'':LzRationalNumberTerm';
		"Negation rules"
		rule: '∀ x_:ℤ -(x_) → ''x negated'':LzIntegerTerm';
		rule: '∀ x_:ℚ -(x_) → ''x negated'':LzRationalNumberTerm';
		"Multiplication rules"
		rule: '∀ x_:ℤ ∀ y_:ℤ x_ × y_ → ''x * y'':LzIntegerTerm';
		rule: '∀ x_:ℚ ∀ y_:ℚ x_ × y_ → ''x * y'':LzRationalNumberTerm';
		"Division rules"
		rule: '∀ x_:ℚ ∀ y_:ℚ.nz x_ ÷ y_ → ''x / y'':LzRationalNumberTerm';
		"Integer div and rem rules"
		rule: '∀ x_:ℤ ∀ y_:ℤ.nz x_ div y_ → ''(x abs // y abs) * x sign * y sign'':LzIntegerTerm';
		rule: '∀ x_:ℤ ∀ y_:ℤ.nz x_ rem y_ → ''(x abs % y abs) * x sign * y sign'':LzIntegerTerm';
		"Exponentiation rules"
		rule: '∀ x_:ℤ ∀ y_:ℕ.nz x_^(y_) → ''x raisedTo: y'':LzIntegerTerm';
		rule: '∀ x_:ℚ.nz ∀ y_:ℤ.nz x_^(y_) → ''x raisedTo: y'':LzRationalNumberTerm';
		"Abs rules"
		rule: '∀ x_:ℤ abs(x_) → ''x abs'':LzIntegerTerm';
		rule: '∀ x_:ℚ abs(x_) → ''x abs'':LzRationalNumberTerm'.
]

{ #category : #defining }
LzBuiltinContexts class >> rationalNumberContext [
	RationalNumberContext ifNil: [
		| builder |
		builder := LzContextBuilder new
			include: self truthContext;
			builtin: #integers;
			builtin: #rationalNumbers.
		self integerSortsFor: builder.
		self rationalNumberSortsFor: builder.
		self integerOpsFor: builder.
		self rationalNumberOpsFor: builder.
		"No integerAxioms, because they would be redundant."
		self rationalNumberAxiomsFor:  builder.
		"No integerRules, the few that are required are repeated in rationalRules."
		self rationalNumberRulesFor: builder.
		RationalNumberContext := builder context ].
	^ RationalNumberContext
]

{ #category : #private }
LzBuiltinContexts class >> rationalNumberOpsFor: aContextBuilder [
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
LzBuiltinContexts class >> rationalNumberRulesFor: aContextBuilder [
	aContextBuilder
		"addition rules"
		rule: '∀ x_:ℚ ∀ z_:zero x_ + z_ ⇒ x_';
		rule: '∀ x_:ℚ ∀ z_:zero z_ + x_ ⇒ x_';
		"Subtraction rules"
		rule: '∀ x_:ℚ ∀ z_:zero x_ - z_ ⇒ x_';
		rule: '∀ x_:ℚ ∀ z_:zero z_ - x_ ⇒ -(x_)';
		"Negation rules"
		rule: '∀ z_:zero -(z_) ⇒ 0';
		"Multiplication rules"
		rule: '∀ x_:ℚ ∀ z_:zero x_ × z_ ⇒ 0';
		rule: '∀ x_:ℚ ∀ z_:zero z_ × x_ ⇒ 0';
		rule: '∀ x_:ℚ 1 × x_ ⇒ x_';
		rule: '∀ x_:ℚ x_ × 1 ⇒ x_';
		"Division rules"
		rule: '∀ x_:ℚ.nz ∀ z_:zero z_ ÷ x_ ⇒ 0';
		rule: '∀ x_:ℚ x_ ÷ 1 ⇒ x_';
		"Integer div and rem rules"
		rule: '∀ x_:ℤ.nz ∀ z_:zero z_ div x_ ⇒ 0';
		rule: '∀ x_:ℤ x_ div 1 ⇒ x_';
		rule: '∀ x_:ℤ.nz ∀ z_:zero z_ rem x_ ⇒ 0';
		rule: '∀ x_:ℤ x_ rem 1 ⇒ 0';
		"Exponentiation rules"
		rule: '∀ x_:ℚ.nz ∀ z_:zero x_^(z_) ⇒ 1';
		rule: '∀ x_:ℕ.nz ∀ z_:zero z_^(x_) ⇒ 0';
		"Abs rules"
		rule: '∀ x_:ℚ.nn abs(x_) ⇒ x_';
		rule: '∀ x_:ℚ abs(x_) ⇒ -(x_) | x_ < 0';
		"Comparison rules"
		rule: '∀ x_:ℚ ∀ y_:ℚ x_ < y_ → ''x < y'':LzBooleanTerm';
		rule: '∀ x_:ℚ ∀ y_:ℚ x_ > y_ → ''x > y'':LzBooleanTerm';
		rule: '∀ x_:ℚ ∀ y_:ℚ x_ ≤ y_ → ''x <= y'':LzBooleanTerm';
		rule: '∀ x_:ℚ ∀ y_:ℚ x_ ≥ y_ → ''x >= y'':LzBooleanTerm'.
	self rationalNumberBuiltinRulesFor: aContextBuilder
]

{ #category : #private }
LzBuiltinContexts class >> rationalNumberSortsFor: aContextBuilder [
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

{ #category : #defining }
LzBuiltinContexts class >> realNumberArrayContext [
	| builder |
	builder := LzContextBuilder new
		include: self arrayMap2Context;
		include: self arrayFoldContext;
		include: self realNumberContext.
	self numberArrayOpsAndRulesForBuilder: builder sort: 'ℝ'.
	^ builder context
]

{ #category : #private }
LzBuiltinContexts class >> realNumberAxiomsFor: aContextBuilder [
	aContextBuilder
		"addition axioms"
		axiom: '∀ x_:ℝ ∀ y_:ℝ  x_ + y_ = y_ + x_';
		axiom: '∀ x_:ℝ ∀ y_:ℝ  ∀ z_:ℝ  (x_ + y_) + z_ = x_ + (y_ + z_)';
		"multiplication axioms"
		axiom: '∀ x_:ℝ ∀ y_:ℝ  x_ × y_ = y_ × x_';
		axiom: '∀ x_:ℝ ∀ y_:ℝ  ∀ z_:ℝ  (x_ × y_) × z_ = x_ × (y_ × z_)';
		"distribution"
		axiom: '∀ x_:ℝ ∀ y_:ℝ  ∀ z_:ℝ  x_ × (y_ + z_) = (x_ × y_) + (x_ × z_)'.
]

{ #category : #defining }
LzBuiltinContexts class >> realNumberContext [
	RealNumberContext ifNil: [
		| builder |
		builder := LzContextBuilder new
			include: self truthContext;
			builtin: #integers;
			builtin: #rationalNumbers.
		self integerSortsFor: builder.
		self rationalNumberSortsFor: builder.
		self realNumberSortsFor: builder.
		self integerOpsFor: builder.
		self rationalNumberOpsFor: builder.
		self realNumberOpsFor: builder.
		"No rationalNumberAxioms, because they would be redundant."
		self realNumberAxiomsFor: builder.
		"No rationalNumberRules, the few that are required are repeated in realNumberRules."
		self realNumberRulesFor: builder.
		RealNumberContext := builder context ].
	^ RealNumberContext
]

{ #category : #private }
LzBuiltinContexts class >> realNumberOpsFor: builder [
	builder
		"Arithmetic operators"
		op: 'ℝ + ℝ : ℝ';
		op: 'ℝ.p + ℝ.p : ℝ.p';
		op: 'ℝ.nn + ℝ.nn : ℝ.nn';
		op: 'ℝ - ℝ : ℝ';
		op: '-(ℝ) : ℝ';
		op: 'ℝ × ℝ : ℝ';
		op: 'ℝ.p × ℝ.p : ℝ.p';
		op: 'ℝ.nn × ℝ.nn : ℝ.nn';
		op: 'ℝ ÷ ℝ.nz : ℝ';
		op: 'ℝ.nz ÷ ℝ.nz : ℝ.nz';
		op: 'ℝ.p ÷ ℝ.p : ℝ.p';
		op: 'ℝ.nn ÷ ℝ.p : ℝ.nn';
		op: 'ℝ.nz^(zero) : ℕ.nz';
		op: 'ℝ.p^(ℝ.nz) : ℝ.p';
		op: 'ℝ.nz^(ℤ.nz) : ℝ.nz';
		op: 'ℝ^(ℕ.nz) : ℝ';
		"Various functions"
		op: 'abs(ℝ) : ℝ.nn';
		op: 'abs(ℝ.nz) : ℝ.p';
		op: '√(ℝ.nn) : ℝ.nn';
		op: '√(ℝ.p) : ℝ.p';
		"Comparison operators"
		op: #'ℝ < ℝ : 𝔹';
		op: #'ℝ > ℝ : 𝔹';
		op: #'ℝ ≤ ℝ : 𝔹';
		op: #'ℝ ≥ ℝ : 𝔹'.
]

{ #category : #private }
LzBuiltinContexts class >> realNumberRulesFor: aContextBuilder [
	aContextBuilder
		"addition rules"
		rule: '∀ x_:ℝ ∀ zero_:zero x_ + zero_ ⇒ x_';
		rule: '∀ x_:ℝ ∀ zero_:zero zero_ + x_ ⇒ x_';
		"Subtraction rules"
		rule: '∀ x_:ℝ ∀ zero_:zero x_ - zero_ ⇒ x_';
		rule: '∀ x_:ℝ ∀ zero_:zero zero_ - x_ ⇒ -(x_)';
		"Negation rules"
		rule: '∀ zero_:zero -(zero_) ⇒ 0';
		"Multiplication rules"
		rule: '∀ x_:ℝ ∀ zero_:zero x_ × zero_ ⇒ 0';
		rule: '∀ x_:ℝ ∀ zero_:zero zero_ × x_ ⇒ 0';
		rule: '∀ x_:ℝ 1 × x_ ⇒ x_';
		rule: '∀ x_:ℝ x_ × 1 ⇒ x_';
		"Division rules"
		rule: '∀ x_:ℝ.nz ∀ zero_:zero zero_ ÷ x_ ⇒ 0';
		rule: '∀ x_:ℝ x_ ÷ 1 ⇒ x_';
		"Integer div and rem rules"
		rule: '∀ x_:ℤ.nz ∀ z_:zero z_ div x_ ⇒ 0';
		rule: '∀ x_:ℤ x_ div 1 ⇒ x_';
		rule: '∀ x_:ℤ.nz ∀ z_:zero z_ rem x_ ⇒ 0';
		rule: '∀ x_:ℤ x_ rem 1 ⇒ 0';
		"Exponentiation rules"
		rule: '∀ x_:ℝ.nz ∀ zero_:zero x_^(zero_) ⇒ 1';
		rule: '∀ x_:ℕ.nz ∀ z_:zero z_^(x_) ⇒ 0';
		"Abs rules"
		rule: '∀ x_:ℝ.nn abs(x_) ⇒ x_';
		rule: '∀ x_:ℝ abs(x_) ⇒ -(x_) | x_ < 0';
		"Comparison rules"
		rule: '∀ x_:ℝ ∀ y_:ℝ x_ < y_ → ''x < y'':LzBooleanTerm';
		rule: '∀ x_:ℝ ∀ y_:ℝ x_ > y_ → ''x > y'':LzBooleanTerm';
		rule: '∀ x_:ℝ ∀ y_:ℝ x_ ≤ y_ → ''x <= y'':LzBooleanTerm';
		rule: '∀ x_:ℝ ∀ y_:ℝ x_ ≥ y_ → ''x >= y'':LzBooleanTerm'.
	self rationalNumberBuiltinRulesFor: aContextBuilder
]

{ #category : #private }
LzBuiltinContexts class >> realNumberSortsFor: builder [
	builder
		sort: 'ℝ';
		sort: 'ℝ.nz';
		sort: 'ℝ.nn';
		sort: 'ℝ.p';
		subsort: 'ℚ ⊆ ℝ';
		subsort: 'ℝ.nz ⊆ ℝ';
		subsort: 'ℚ.nz ⊆ ℝ.nz';
		subsort: 'ℝ.p ⊆ ℝ.nz';
		subsort: 'ℚ.p ⊆ ℝ.p';
		subsort: 'ℝ.nn ⊆ ℝ';
		subsort: 'ℝ.p ⊆ ℝ.nn';
		subsort: 'ℚ.nn ⊆ ℝ.nn'.
]

{ #category : #resetting }
LzBuiltinContexts class >> reset [
	TruthContext := nil.
	EqualityContext := nil.
	IntegerContext := nil.
	RationalNumberContext := nil.
	RealNumberContext := nil.
	StringContext := nil.
	ArrayContext := nil.
]

{ #category : #defining }
LzBuiltinContexts class >> sortContext [
	^ LzSortHierarchyRoot uniqueInstance sortContext
]

{ #category : #defining }
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

{ #category : #defining }
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
