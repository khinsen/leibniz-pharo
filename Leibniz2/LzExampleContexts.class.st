"
The contexts defined in the methods of this class are standard Leibniz contexts. They are provided because they are useful and/or because they are used in other example code.
"
Class {
	#name : #LzExampleContexts,
	#superclass : #Object,
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #defining }
LzExampleContexts class >> booleanContext [
	| builder |
	builder := LzContextBuilder new
		include: LzBuiltinContexts truthContext;
		op: '¬(𝔹) : 𝔹';
		op: '𝔹 ∧ 𝔹 : 𝔹';
		op: '𝔹 ∨ 𝔹 : 𝔹';
		op: '𝔹 ⊻ 𝔹 : 𝔹';
		axiom: '∀ x_:𝔹 ∀ y_:𝔹 x_ ∧ y_ = y_ ∧ x_';
		axiom: '∀ x_:𝔹 ∀ y_:𝔹 ∀ z_:𝔹 (x_ ∧ y_) ∧ z_ = x_ ∧ (y_ ∧ z_)';
		axiom: '∀ x_:𝔹 ∀ y_:𝔹 x_ ∨ y_ = y_ ∨ x_';
		axiom: '∀ x_:𝔹 ∀ y_:𝔹 ∀ z_:𝔹 (x_ ∨ y_) ∨ z_ = x_ ∨ (y_ ∨ z_)';
		axiom: '∀ x_:𝔹 ∀ y_:𝔹 x_ ⊻ y_ = y_ ⊻ x_';
		axiom: '∀ x_:𝔹 ∀ y_:𝔹 ∀ z_:𝔹 (x_ ⊻ y_) ⊻ z_ = x_ ⊻ (y_ ⊻ z_)'.
	self booleanRulesFor: builder.
	^ builder context
]

{ #category : #private }
LzExampleContexts class >> booleanRulesFor: builder [
	builder
		"1. Eliminate NOT and OR"

		"1a. NOT is replaced by XOR with ⊤"
		rule: '∀ x_:𝔹 ¬(x_) ⇒ ⊤ ⊻ x_';

		"1b. OR is replaced by XOR and AND"
		rule: '∀ y_:𝔹  ∀ x_:𝔹 x_ ∨ y_ ⇒ x_ ⊻ y_ ⊻ (x_ ∧ y_)';

		"2 Simplify AND relations"

		"2a. AND is ⊥ if one of its arguments is ⊥"
		rule: '∀ x_:𝔹 x_ ∧ ⊥ ⇒ ⊥';
		rule: '∀ x_:𝔹 ⊥ ∧ x_ ⇒ ⊥';

		"2b. If one argument of AND is ⊤, the result is the other argument"
		rule: '∀ x_:𝔹 x_ ∧ ⊤ ⇒ x_';
		rule: '∀ x_:𝔹 ⊤ ∧ x_ ⇒ x_';

		"2c. If the two arguments to AND are equal, they are also equal to the result"
		rule: '∀ x_:𝔹 x_ ∧ x_ ⇒ x_';

		"3 Simplify XOR relations"

		"3a. XOR with ⊥ leaves truth values unchanged"
		rule: '∀ x_:𝔹 x_ ⊻ ⊥ ⇒ x_';
		rule: '∀ x_:𝔹 ⊥ ⊻ x_ ⇒ x_';

		"3b. If the two arguments to XOR are equal, the result is ⊥"
		rule: '∀ x_:𝔹 x_ ⊻ x_ ⇒ ⊥';

		"4. Standardize combinations of XOR and AND"
		rule: '∀ x_:𝔹 ∀ y_:𝔹 ∀ z_:𝔹 x_ ∧ (y_ ⊻ z_) ⇒ (x_ ∧ y_) ⊻ (x_ ∧ z_)'.
]

{ #category : #private }
LzExampleContexts class >> collectionConstructorOpsFor: builder [
	builder
		op: '∅ : ∅';
		op: '∀ s_:𝕊 ∀ n_:ℕ ∀ m_:ℕ ',
				'(list(s_, n_)) ++ (list(s_, m_)) : list(s_, n_ + m_)';
		op: '∀ s_:𝕊 ',
				'(list(s_)) ++ (list(s_)) : list(s_)';
		op: '∀ s_:𝕊 ∀ n_:ℕ ∀ m_:ℕ ',
				'(bag(s_, n_)) ++ (bag(s_, m_)) : bag(s_, n_ + m_)';
		op: '∀ s_:𝕊 ',
				'(bag(s_)) ++ (bag(s_)) : bag(s_)';
		op: '∀ s_:𝕊 ',
				'(set(s_)) ++ (set(s_)) : set(s_)';
		op: '∀ s_:𝕊 ∀ n_:ℕ ',
				'(list(s_, n_)) ++ s_ : list(s_, n_ + 1)';
		op: '∀ s_:𝕊 ∀ n_:ℕ ',
				'(bag(s_, n_)) ++ s_ : bag(s_, n_ + 1)';
		op: '∀ s_:𝕊 ',
				'(list(s_)) ++ s_ : list(s_)';
		op: '∀ s_:𝕊 ',
				'(bag(s_)) ++ s_ : bag(s_)';
		op: '∀ s_:𝕊 ',
				'(set(s_)) ++ s_ : set(s_)';
		op: '∀ s_:𝕊 ',
				'∅ ++ s_ : list(s_, 1)';
		op: '∀ s_:𝕊 ',
				'singleton(s_) : list(s_, 1)'
]

{ #category : #defining }
LzExampleContexts class >> collectionContext [
	| builder |
	builder := LzContextBuilder new
		includeSortContext: LzBuiltinContexts integerContext.
	self collectionSortsFor: builder. 
	self collectionConstructorOpsFor: builder.
	self constructionAccessorsFor: builder.
	^ builder context
]

{ #category : #private }
LzExampleContexts class >> collectionSortsFor: builder [
	builder
		sort: 'collection';
		sort: '∅';
		subsort: '∅ ⊆ collection';
		sort: 'list(𝕊, ℕ)';
		sort: 'bag(𝕊, ℕ)';
		sort: 'list(𝕊)';
		sort: 'bag(𝕊)';
		sort: 'set(𝕊)';
		subsort: '∀ s_:𝕊 ∀ n_:ℕ list(s_, n_) ⊆ bag(s_, n_)';
		subsort: '∀ s_:𝕊 ∀ n_:ℕ list(s_, n_) ⊆ list(s_)';
		subsort: '∀ s_:𝕊 ∀ n_:ℕ bag(s_, n_) ⊆ bag(s_)';
		subsort: '∀ s_:𝕊 list(s_) ⊆ bag(s_)';
		subsort: '∀ s_:𝕊 bag(s_) ⊆ set(s_)';
		subsort: '∀ s_:𝕊 set(s_) ⊆ collection'
]

{ #category : #private }
LzExampleContexts class >> constructionAccessorsFor: builder [
	builder
		op: '∀ s_:𝕊 ∀ n_:ℕ.nz ',
				'allButLast(list(s_, n_)) : list(s_, pred(n_))';
		rule: '∀ s__:𝕊 ∀ n__:ℕ ∀ l_:list(s__, n__) ∀ e_:s__ ',
				'allButLast(l_ ++ e_) ⇒ l_';
		op: '∀ s_:𝕊 ∀ n_:ℕ.nz ',
				'last(list(s_, n_)) : s_';
		rule: '∀ s__:𝕊 ∀ n__:ℕ ∀ l_:list(s__, n__) ∀ e_:s__ ',
				'last(l_ ++ e_) ⇒ e_'
]

{ #category : #private }
LzExampleContexts class >> geometricAlgebra3DBasisFor: builder [
	builder
		op: 'e1 : Vector';
		op: 'e2 : Vector';
		op: 'e3 : Vector';
		rule: 'e1 × e1 ⇒ 1';
		rule: 'e2 × e2 ⇒ 1';
		rule: 'e3 × e3 ⇒ 1';
		axiom: 'e1 × e2 = -(e2 × e1)';
		axiom: 'e2 × e3 = -(e3 × e2)';
		axiom: 'e3 × e1 = -(e1 × e3)';

		op: 'i : Pseudoscalar';
		rule: 'i × i ⇒ -1';
		axiom: 'i = e1 × e2 × e3';
		axiom: '∀ x_:Multivector i × x_ = x_ × i';
		axiom: 'e1 × e2 = i × e3';
		axiom: 'e2 × e3 = i × e1';
		axiom: 'e3 × e1 = i × e2';

		op: 'v(ℝ, ℝ, ℝ) : Vector';
		axiom: '∀ x_:ℝ ∀ y_:ℝ ∀ z_:ℝ ',
				'v(x_, y_, z_) = ((x_ × e1) + (y_ × e2) + (z_ × e3))'
]

{ #category : #defining }
LzExampleContexts class >> geometricAlgebra3DContext [
	| builder |
	builder := LzContextBuilder new
		include: LzBuiltinContexts realNumberContext.
	self geometricAlgebra3DSortsFor: builder.
	self geometricAlgebra3DSumsFor: builder.
	self geometricAlgebra3DProductsFor: builder.
	self geometricAlgebra3DBasisFor: builder.
	self geometricAlgebra3DSimplificationsFor: builder.
	^ builder context
]

{ #category : #private }
LzExampleContexts class >> geometricAlgebra3DProductsFor: builder [
	builder
		op: 'Multivector × Multivector : Multivector';
		op: 'ℝ × Vector : Vector';
		op: 'Vector × ℝ : Vector';
		op: 'ℝ × Bivector : Bivector';
		op: 'Bivector × ℝ : Bivector';
		op: 'ℝ × Pseudoscalar : Pseudoscalar';
		op: 'Pseudoscalar × ℝ : Pseudoscalar';
		op: 'Vector × Pseudoscalar : Bivector';
		op: 'Pseudoscalar × Vector : Bivector';
		op: 'Bivector × Pseudoscalar : Vector';
		op: 'Pseudoscalar × Bivector : Vector';
		axiom: '∀ x_:Multivector ∀ y_:Multivector ∀ z_:Multivector  (x_ × y_) × z_ = x_ × (y_ × z_)';
		axiom: '∀ x_:Multivector ∀ y_:Multivector ∀ z_:Multivector  x_ × (y_ + z_) = (x_ × y_) + (x_ × z_)';
		axiom: '∀ x_:Multivector ∀ y_:Multivector ∀ z_:Multivector  (x_ + y_) × z_ = (x_ × z_) + (y_ × z_)';
		rule: '∀ x_:Multivector 1 × x_ ⇒ x_';
		rule: '∀ x_:Multivector x_ × 1 ⇒ x_';
		rule: '∀ zero_:zero ∀ x_:Multivector zero_ × x_ ⇒ 0';
		rule: '∀ zero_:zero ∀ x_:Multivector x_ × zero_ ⇒ 0';

		op: 'Multivector ∧ Multivector : Multivector';
		op: 'ℝ ∧ Vector : Vector';
		op: 'Vector ∧ ℝ : Vector';
		op: 'Vector ∧ Vector : Bivector';
		op: 'Vector ∧ Bivector : Pseudoscalar';
		op: 'Bivector ∧ Vector : Pseudoscalar';
		axiom: '∀ x_:Multivector ∀ y_:Multivector x_ ∧ y_ = -(y_ ∧ x_)';
		axiom: '∀ x_:Multivector ∀ y_:Multivector ∀ z_:Multivector  (x_ ∧ y_) ∧ z_ = x_ ∧ (y_ ∧ z_)';
		axiom: '∀ x_:Multivector ∀ y_:Multivector ∀ z_:Multivector  x_ ∧ (y_ + z_) = (x_ ∧ y_) + (x_ ∧ z_)';
		axiom: '∀ x_:Multivector ∀ y_:Multivector ∀ z_:Multivector  (x_ + y_) ∧ z_ = (x_ ∧ z_) + (y_ ∧ z_)';
		axiom: '∀ x_:Multivector ∀ y_:Multivector x_ ∧ y_ = 1/2 × ((x_ × y_) - (y_ × x_))';
		rule: '∀ x_:Multivector 1 ∧ x_ ⇒ x_';
		rule: '∀ x_:Multivector x_ ∧ 1 ⇒ x_';
		rule: '∀ zero_:zero ∀ x_:Multivector zero_ ∧ x_ ⇒ 0';
		rule: '∀ zero_:zero ∀ x_:Multivector x_ ∧ zero_ ⇒ 0';
		rule: '∀ x_:Vector x_ ∧ x_ ⇒ 0';

		op: 'Vector ⋅ Vector: ℝ';
		axiom: '∀ x_:Vector ∀ y_:Vector x_ ⋅ y_ = 1/2 × ((x_ × y_) + (y_ × x_))';

		op: 'sq(Vector): ℝ.nn';
		rule: '∀ x_:Vector x_ × x_ ⇒ sq(x_)';
		rule: '∀ x_:Vector x_ ⋅ x_ ⇒ sq(x_)';

		op: 'norm(Vector): ℝ.nn';
		axiom: '∀ v_:Vector norm(v_) = √(sq(v_))'
]

{ #category : #defining }
LzExampleContexts class >> geometricAlgebra3DSimplificationsFor: builder [
	builder
		rule: '∀ s_:ℝ ∀ v_:Vector sq(s_ × v_) ⇒ s_^(2) × sq(v_)';
		rule: '∀ s_:ℝ ∀ x_:ℝ ∀ y_:ℝ ∀ z_:ℝ ',
				's_ × v(x_, y_, z_) ⇒ v(s_ × x_, s_ × y_, s_ × z_)';
		rule: '∀ x1_:ℝ ∀ y1_:ℝ ∀ z1_:ℝ ',
				'∀ x2_:ℝ ∀ y2_:ℝ ∀ z2_:ℝ ',
				'v(x1_, y1_, z1_) + v(x2_, y2_, z2_)',
				'⇒ v(x1_ + x2_, y1_ + y2_, z1_ + z2_)';
		rule: '∀ x1_:ℝ ∀ y1_:ℝ ∀ z1_:ℝ ',
				'∀ x2_:ℝ ∀ y2_:ℝ ∀ z2_:ℝ ',
				'v(x1_, y1_, z1_) - v(x2_, y2_, z2_)',
				'⇒ v(x1_ - x2_, y1_ - y2_, z1_ - z2_)';
		rule: '∀ x_:ℝ ∀ y_:ℝ ∀ z_:ℝ ',
				'sq(v(x_, y_, z_)) ⇒ (x_ × x_) + (y_ × y_) + (z_ × z_)';
		rule: '∀ x_:ℝ ∀ y_:ℝ ∀ z_:ℝ ',
				'norm(v(x_, y_, z_)) ⇒ √(sq(v(x_, y_, z_)))'
]

{ #category : #private }
LzExampleContexts class >> geometricAlgebra3DSortsFor: builder [
	builder
		sort: 'Multivector';
		sort: 'Vector';
		sort: 'Bivector';
		sort: 'Pseudoscalar';
		subsort: 'ℝ ⊆ Multivector';
		subsort: 'Vector ⊆ Multivector';
		subsort: 'Bivector ⊆ Multivector';
		subsort: 'Pseudoscalar ⊆ Multivector'
]

{ #category : #private }
LzExampleContexts class >> geometricAlgebra3DSumsFor: builder [
	builder
		op: 'Multivector + Multivector : Multivector';
		op: 'Vector + Vector : Vector';
		op: 'Bivector + Bivector : Bivector';
		op: 'Pseudoscalar + Pseudoscalar : Pseudoscalar';
		axiom: '∀ x_:Multivector ∀ y_:Multivector  x_ + y_ = y_ + x_';
		axiom: '∀ x_:Multivector ∀ y_:Multivector  ∀ z_:Multivector  (x_ + y_) + z_ = x_ + (y_ + z_)';

		op: 'Multivector - Multivector : Multivector';
		op: 'Vector - Vector : Vector';
		op: 'Bivector - Bivector : Bivector';
		op: 'Pseudoscalar - Pseudoscalar : Pseudoscalar';

		op: '-(Multivector) : Multivector';
		op: '-(Vector) : Vector';
		op: '-(Bivector) : Bivector';
		op: '-(Pseudoscalar) : Pseudoscalar'
]

{ #category : #defining }
LzExampleContexts class >> mapContext [
	^ LzContextBuilder new
		include: LzBuiltinContexts functionContext;
		include: self collectionContext;
		op: '∀ from_:𝕊 ∀ to_:𝕊 ∀ n_:ℕ ',
			'map(fn(from_, to_), list(from_, n_)) : list(to_, n_)';
		op: '∀ from_:𝕊 ∀ to_:𝕊 ∀ n_:ℕ ',
			'map(fn(from_, to_), ∅) : ∅';
		rule: '∀ from__:𝕊 ∀ to__:𝕊 ∀ f_:fn(from__, to__) ',
				'∀ n__:ℕ ∀ l_:list(from__, n__) ∀ e_:from__ ',
				'map(f_, l_ ++ e_) ⇒ map(f_, l_) ++ f_[e_]';
		rule: '∀ from__:𝕊 ∀ to__:𝕊 ∀ f_:fn(from__, to__) ',
				'∀ e_:from__ ',
				'map(f_, ∅ ++ e_) ⇒ ∅ ++ f_[e_]';
		rule: '∀ from__:𝕊 ∀ to__:𝕊 ∀ f_:fn(from__, to__) ',
				'map(f_, ∅) ⇒ ∅';
		op: '∀ from_:𝕊 ∀ to_:𝕊 ∀ n_:ℕ ',
				'(fn(from_, to_))[list(from_, n_)] : list(to_, n_)';
		rule: '∀ from__:𝕊 ∀ to__:𝕊 ',
				'∀ f_:fn(from__, to__) ∀ n__:ℕ  ∀ l_:list(from__, n__) ',
				'f_[l_] ⇒ map(f_, l_)';
		context
]
