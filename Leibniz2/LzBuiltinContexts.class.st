Class {
	#name : #LzBuiltinContexts,
	#superclass : #Object,
	#category : #'Leibniz2-Leibniz2'
}

{ #category : #accessing }
LzBuiltinContexts class >> integerContext [
	| builder |
	builder := LzContextBuilder new
		include: self truthContext;
		builtin: #integers.
	self integerSortsFor: builder.
	self integerOpsFor: builder.
	self integerRulesFor: builder.
	^ builder context
]

{ #category : #private }
LzBuiltinContexts class >> integerOpsFor: aContextBuilder [
	aContextBuilder
		"Arithmetic operators"
		op: 'ℤ + ℤ : ℤ';
		op: 'ℕ + ℕ : ℕ';
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
		op: 'ℤ^{ℕ.nz} : ℤ';
		op: 'ℕ^{ℕ.nz} : ℕ';
		op: 'ℕ.nz^{ℕ.nz} : ℕ.nz';
		op: 'ℤ.nz^{ℕ.nz} : ℤ.nz';
		op: 'ℤ.nz^{zero} : ℕ.nz';
		op: 'abs(ℤ) : ℕ';
		op: 'abs(ℤ.nz) : ℕ.nz';
		"Comparison operators"
		op: 'ℤ < ℤ : boolean';
		op: 'ℤ > ℤ : boolean';
		op: 'ℤ ≤ ℤ : boolean';
		op: 'ℤ ≥ ℤ : boolean'.
]

{ #category : #private }
LzBuiltinContexts class >> integerRulesFor: aContextBuilder [
	aContextBuilder
		"addition rules"
		rule: '∀ ?x:ℤ ∀ ?zero:zero ?x + ?zero ⇒ ?x';
		rule: '∀ ?x:ℤ ∀ ?zero:zero ?zero + ?x ⇒ ?x';
		rule: '∀ ?x:ℤ ∀ ?y:ℤ ?x + ?y → ''x + y'':LzIntegerTerm';
		"subtraction rules"
		rule: '∀ ?x:ℤ ∀ ?zero:zero ?x - ?zero ⇒ ?x';
		rule: '∀ ?x:ℤ ∀ ?zero:zero ?zero - ?x ⇒ -(?x)';
		rule: '∀ ?x:ℤ ∀ ?y:ℤ ?x - ?y → ''x - y'':LzIntegerTerm';
		rule: '∀ ?zero:zero -(?zero) ⇒ 0';
		rule: '∀ ?x:ℤ -(?x) → ''x negated'':LzIntegerTerm';
		"multiplication rules"
		rule: '∀ ?x:ℤ ∀ ?zero:zero ?x × ?zero ⇒ 0';
		rule: '∀ ?x:ℤ ∀ ?zero:zero ?zero × ?x ⇒ 0';
		rule: '∀ ?x:ℤ 1 × ?x ⇒ ?x';
		rule: '∀ ?x:ℤ ?x × 1 ⇒ ?x';
		rule: '∀ ?x:ℤ ∀ ?y:ℤ ?x × ?y → ''x * y'':LzIntegerTerm';
		"division rules"
		rule: '∀ ?x:ℤ.nz ∀ ?zero:zero ?zero div ?x ⇒ 0';
		rule: '∀ ?x:ℤ ?x div 1 ⇒ ?x';
		rule: '∀ ?x:ℤ ∀ ?y:ℤ.nz ?x div ?y → ''(x abs // y abs) * x sign * y sign'':LzIntegerTerm';
		rule: '∀ ?x:ℤ.nz ∀ ?zero:zero ?zero rem ?x ⇒ 0';
		rule: '∀ ?x:ℤ ?x rem 1 ⇒ 0';
		rule: '∀ ?x:ℤ ∀ ?y:ℤ.nz ?x rem ?y → ''(x abs % y abs) * x sign * y sign'':LzIntegerTerm';
		"exponentiation rules"
		rule: '∀ ?x:ℤ.nz ∀ ?zero:zero ?x^{?zero} ⇒ 1';
		rule: '∀ ?x:ℕ.nz ∀ ?zero:zero ?zero^{?x} ⇒ 0';
		rule: '∀ ?x:ℤ ∀ ?y:ℕ.nz ?x^{?y} → ''x raisedTo: y'':LzIntegerTerm';
		"abs rules"
		rule: '∀ ?x:ℕ abs(?x) ⇒ ?x';
		rule: '∀ ?x:ℤ abs(?x) ⇒ -(?x) | ?x < 0';
		rule: '∀ ?x:ℤ abs(?x) → ''x abs'':LzIntegerTerm'.
		"comparison rules"
"		rule: '∀ ?x:ℤ ∀ ?y:ℤ ?x < ?y → ''x < y'':LzBooleanTerm';
		rule: '∀ ?x:ℤ ∀ ?y:ℤ ?x > ?y → ''x > y'':LzBooleanTerm';
		rule: '∀ ?x:ℤ ∀ ?y:ℤ ?x ≤ ?y → ''x <= y'':LzBooleanTerm';
		rule: '∀ ?x:ℤ ∀ ?y:ℤ ?x ≥ ?y → ''x >= y'':LzBooleanTerm'."
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

{ #category : #accessing }
LzBuiltinContexts class >> sortContext [
	^ LzSortHierarchyRoot uniqueInstance sortContext
]

{ #category : #accessing }
LzBuiltinContexts class >> truthContext [
	^ LzContextBuilder new
		sort: 'boolean';
		op: 'true : boolean';
		op: 'false : boolean';
		context
]
